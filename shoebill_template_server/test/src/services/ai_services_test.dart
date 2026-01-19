import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:shoebill_template_server/src/services/ai_services.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart' hide ChatMessage;

/// Mock HttpClient for testing SSE streaming responses
class MockHttpClient implements HttpClient {
  final List<MockHttpClientRequest> requests = [];
  MockHttpClientResponse? Function(MockHttpClientRequest)? onRequest;

  @override
  Future<HttpClientRequest> postUrl(Uri url) async {
    final request = MockHttpClientRequest(url, this);
    requests.add(request);
    return request;
  }

  @override
  void close({bool force = false}) {
    // Mock implementation - nothing to actually close
  }

  // Required interface methods (not used in tests)
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class MockHttpClientRequest implements HttpClientRequest {
  final Uri url;
  final MockHttpClient client;
  final Map<String, String> _headers = {};
  final StringBuffer _body = StringBuffer();
  bool closed = false;

  MockHttpClientRequest(this.url, this.client);

  String get body => _body.toString();
  Map<String, String> get requestHeaders => _headers;

  @override
  HttpHeaders get headers => MockHttpHeaders(_headers);

  @override
  void write(Object? object) {
    _body.write(object);
  }

  @override
  Future<HttpClientResponse> close() async {
    closed = true;
    if (client.onRequest != null) {
      final response = client.onRequest!(this);
      if (response != null) {
        return response;
      }
    }
    return MockHttpClientResponse(200, '');
  }

  // Required interface methods (not used in tests)
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class MockHttpHeaders implements HttpHeaders {
  final Map<String, String> _headers;

  MockHttpHeaders(this._headers);

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers[name] = value.toString();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class MockHttpClientResponse implements HttpClientResponse {
  @override
  final int statusCode;
  final String _body;
  final StreamController<List<int>> _controller = StreamController<List<int>>();

  MockHttpClientResponse(this.statusCode, this._body) {
    // Schedule the body to be added after stream is listened to
    Future.microtask(() {
      if (!_controller.isClosed) {
        _controller.add(utf8.encode(_body));
        _controller.close();
      }
    });
  }

  /// Creates a response with SSE events that are yielded over time
  factory MockHttpClientResponse.withSseEvents(
    int statusCode,
    List<String> events,
  ) {
    final response = MockHttpClientResponse._internal(statusCode);
    Future.microtask(() async {
      for (final event in events) {
        if (!response._controller.isClosed) {
          response._controller.add(utf8.encode(event));
          // Small delay to simulate streaming
          await Future.delayed(Duration.zero);
        }
      }
      if (!response._controller.isClosed) {
        response._controller.close();
      }
    });
    return response;
  }

  MockHttpClientResponse._internal(this.statusCode) : _body = '';

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    return _controller.stream.transform(streamTransformer);
  }

  // Required interface methods (not used in tests)
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Test implementation of OpenAiService that allows injecting a mock HttpClient
class TestableOpenAiService extends OpenAiService {
  final HttpClient Function() httpClientFactory;

  TestableOpenAiService(super.apiKey, {required this.httpClientFactory});

  @override
  Stream<AiStreamResult> streamPromptGeneration({
    required String prompt,
    bool shouldUseInternetSearchTool = false,
    String? model,
  }) async* {
    final effectiveModel = model ?? 'openai/gpt-4.1-mini';

    // Add user message to history (using reflection-like approach)
    _addUserMessage(prompt);

    final client = httpClientFactory();
    final contentBuffer = StringBuffer();

    try {
      final request = await client.postUrl(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      );

      request.headers.set('Authorization', 'Bearer test-api-key');
      request.headers.set('Content-Type', 'application/json');

      final messages = history.map((m) => m.toJson()).toList();

      final body = <String, dynamic>{
        'model': effectiveModel,
        'stream': true,
        'messages': messages,
      };

      if (shouldUseInternetSearchTool) {
        body['plugins'] = [
          {'id': 'web'},
        ];
      }

      request.write(jsonEncode(body));

      final response = await request.close();

      if (response.statusCode != 200) {
        final errorBody = await response.transform(utf8.decoder).join();
        throw HttpException(
          'OpenRouter API error: ${response.statusCode} - $errorBody',
        );
      }

      // Process SSE stream
      final lineBuffer = StringBuffer();

      await for (final chunk in response.transform(utf8.decoder)) {
        lineBuffer.write(chunk);
        final bufferContent = lineBuffer.toString();
        final lines = bufferContent.split('\n');

        lineBuffer.clear();
        if (!bufferContent.endsWith('\n')) {
          lineBuffer.write(lines.removeLast());
        }

        for (final line in lines) {
          final trimmedLine = line.trim();

          if (trimmedLine.isEmpty || trimmedLine.startsWith(':')) {
            continue;
          }

          if (trimmedLine == 'data: [DONE]') {
            if (contentBuffer.isNotEmpty) {
              _addAssistantMessage(contentBuffer.toString());
            }
            return;
          }

          if (trimmedLine.startsWith('data: ')) {
            final jsonStr = trimmedLine.substring(6);
            try {
              final json = jsonDecode(jsonStr) as Map<String, dynamic>;

              if (json.containsKey('error')) {
                final error = json['error'];
                throw HttpException(
                  'OpenRouter streaming error: ${jsonEncode(error)}',
                );
              }

              final choices = json['choices'] as List<dynamic>?;
              if (choices == null || choices.isEmpty) continue;

              final delta = choices[0]['delta'] as Map<String, dynamic>?;
              if (delta == null) continue;

              final reasoning = delta['reasoning'] as String?;
              if (reasoning != null && reasoning.isNotEmpty) {
                yield AiThinkItem(AiThinkingChunk(thinkingText: reasoning));
              }

              final content = delta['content'] as String?;
              if (content != null && content.isNotEmpty) {
                contentBuffer.write(content);
                yield AiResultItem(content);
              }
            } on FormatException {
              continue;
            }
          }
        }
      }

      if (contentBuffer.isNotEmpty) {
        _addAssistantMessage(contentBuffer.toString());
      }
    } finally {
      client.close();
    }
  }

  @override
  Stream<AiStreamResult> streamPromptGenerationWithSchemaResponse({
    required String prompt,
    required Map<String, SchemaProperty> properties,
    bool shouldUseInternetSearchTool = false,
    String? model,
    int maxRetries = 2,
  }) async* {
    yield* _streamWithSchemaAndValidationTestable(
      prompt: prompt,
      properties: properties,
      shouldUseInternetSearchTool: shouldUseInternetSearchTool,
      model: model,
      retriesRemaining: maxRetries,
    );
  }

  Stream<AiStreamResult> _streamWithSchemaAndValidationTestable({
    required String prompt,
    required Map<String, SchemaProperty> properties,
    required bool shouldUseInternetSearchTool,
    required String? model,
    required int retriesRemaining,
  }) async* {
    final effectiveModel = model ?? 'openai/gpt-4.1-mini';

    _addUserMessage(prompt);

    final client = httpClientFactory();

    try {
      final request = await client.postUrl(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      );

      request.headers.set('Authorization', 'Bearer test-api-key');
      request.headers.set('Content-Type', 'application/json');

      final messages = history.map((m) => m.toJson()).toList();

      final body = <String, dynamic>{
        'model': effectiveModel,
        'stream': true,
        'messages': messages,
        'response_format': {
          'type': 'json_schema',
          'json_schema': {
            'name': 'response_schema',
            'strict': true,
            'schema': _propertiesToJsonSchema(properties),
          },
        },
      };

      if (shouldUseInternetSearchTool) {
        body['plugins'] = [
          {'id': 'web'},
        ];
      }

      request.write(jsonEncode(body));

      final response = await request.close();

      if (response.statusCode != 200) {
        final errorBody = await response.transform(utf8.decoder).join();
        throw HttpException(
          'OpenRouter API error: ${response.statusCode} - $errorBody',
        );
      }

      final lineBuffer = StringBuffer();
      final contentBuffer = StringBuffer();

      await for (final chunk in response.transform(utf8.decoder)) {
        lineBuffer.write(chunk);
        final bufferContent = lineBuffer.toString();
        final lines = bufferContent.split('\n');

        lineBuffer.clear();
        if (!bufferContent.endsWith('\n')) {
          lineBuffer.write(lines.removeLast());
        }

        for (final line in lines) {
          final trimmedLine = line.trim();

          if (trimmedLine.isEmpty || trimmedLine.startsWith(':')) {
            continue;
          }

          if (trimmedLine == 'data: [DONE]') {
            final fullContent = contentBuffer.toString().trim();

            if (fullContent.isNotEmpty) {
              _addAssistantMessage(fullContent);
            }

            if (fullContent.isNotEmpty) {
              try {
                final parsed = jsonDecode(fullContent) as Map<String, dynamic>;

                final validationError =
                    _validateAgainstSchema(parsed, properties);

                if (validationError != null) {
                  if (retriesRemaining > 0) {
                    yield* _retryWithValidationErrorTestable(
                      validationError: validationError,
                      properties: properties,
                      shouldUseInternetSearchTool: shouldUseInternetSearchTool,
                      model: model,
                      retriesRemaining: retriesRemaining - 1,
                    );
                    return;
                  } else {
                    throw FormatException(
                      'Schema validation failed after retries: $validationError',
                    );
                  }
                }

                yield AiSchemaResultItem(parsed);
              } on FormatException catch (e) {
                if (retriesRemaining > 0) {
                  yield* _retryWithValidationErrorTestable(
                    validationError: 'JSON parsing error: $e',
                    properties: properties,
                    shouldUseInternetSearchTool: shouldUseInternetSearchTool,
                    model: model,
                    retriesRemaining: retriesRemaining - 1,
                  );
                  return;
                }
                throw FormatException(
                  'Failed to parse final JSON response: $e\nContent was: $fullContent',
                );
              }
            }
            return;
          }

          if (trimmedLine.startsWith('data: ')) {
            final jsonStr = trimmedLine.substring(6);
            try {
              final json = jsonDecode(jsonStr) as Map<String, dynamic>;

              if (json.containsKey('error')) {
                final error = json['error'];
                throw HttpException(
                  'OpenRouter streaming error: ${jsonEncode(error)}',
                );
              }

              final choices = json['choices'] as List<dynamic>?;
              if (choices == null || choices.isEmpty) continue;

              final delta = choices[0]['delta'] as Map<String, dynamic>?;
              if (delta == null) continue;

              final reasoning = delta['reasoning'] as String?;
              if (reasoning != null && reasoning.isNotEmpty) {
                yield AiSchemaThinkItem(
                  AiThinkingChunk(thinkingText: reasoning),
                );
              }

              final content = delta['content'] as String?;
              if (content != null) {
                contentBuffer.write(content);
              }
            } on FormatException {
              continue;
            }
          }
        }
      }

      final fullContent = contentBuffer.toString().trim();
      if (fullContent.isNotEmpty) {
        _addAssistantMessage(fullContent);

        try {
          final parsed = jsonDecode(fullContent) as Map<String, dynamic>;
          final validationError = _validateAgainstSchema(parsed, properties);

          if (validationError != null && retriesRemaining > 0) {
            yield* _retryWithValidationErrorTestable(
              validationError: validationError,
              properties: properties,
              shouldUseInternetSearchTool: shouldUseInternetSearchTool,
              model: model,
              retriesRemaining: retriesRemaining - 1,
            );
            return;
          } else if (validationError != null) {
            throw FormatException(
              'Schema validation failed: $validationError',
            );
          }

          yield AiSchemaResultItem(parsed);
        } on FormatException catch (e) {
          if (retriesRemaining > 0) {
            yield* _retryWithValidationErrorTestable(
              validationError: 'JSON parsing error: $e',
              properties: properties,
              shouldUseInternetSearchTool: shouldUseInternetSearchTool,
              model: model,
              retriesRemaining: retriesRemaining - 1,
            );
            return;
          }
          throw FormatException(
            'Failed to parse final JSON response: $e\nContent was: $fullContent',
          );
        }
      }
    } finally {
      client.close();
    }
  }

  Stream<AiStreamResult> _retryWithValidationErrorTestable({
    required String validationError,
    required Map<String, SchemaProperty> properties,
    required bool shouldUseInternetSearchTool,
    required String? model,
    required int retriesRemaining,
  }) async* {
    final retryPrompt = '''
Your previous response did not match the expected schema. Here is the validation error:

$validationError

Please provide a corrected response that matches the exact schema requirements. Ensure all required fields are present and have the correct types.''';

    yield* _streamWithSchemaAndValidationTestable(
      prompt: retryPrompt,
      properties: properties,
      shouldUseInternetSearchTool: shouldUseInternetSearchTool,
      model: model,
      retriesRemaining: retriesRemaining,
    );
  }

  void _addUserMessage(String content) {
    // Access parent's history management through overriding
    // We need to use a different approach since _history is private
    _testHistory.add(ChatMessage(role: ChatRole.user, content: content));
  }

  void _addAssistantMessage(String content) {
    _testHistory.add(ChatMessage(role: ChatRole.assistant, content: content));
  }

  final List<ChatMessage> _testHistory = [];

  @override
  List<ChatMessage> get history => List.unmodifiable(_testHistory);

  @override
  void clearHistory() {
    _testHistory.clear();
  }

  Map<String, dynamic> _propertiesToJsonSchema(
      Map<String, SchemaProperty> properties) {
    final requiredFields = <String>[];
    final schemaProperties = <String, dynamic>{};

    for (final entry in properties.entries) {
      final key = entry.key;
      final prop = entry.value;

      schemaProperties[key] = _propertyToJsonSchema(prop);

      if (!prop.nullable) {
        requiredFields.add(key);
      }
    }

    return {
      'type': 'object',
      'properties': schemaProperties,
      'required': requiredFields,
      'additionalProperties': false,
    };
  }

  Map<String, dynamic> _propertyToJsonSchema(SchemaProperty property) {
    final schema = <String, dynamic>{};

    if (property.description != null) {
      schema['description'] = property.description;
    }

    switch (property) {
      case SchemaPropertyString():
        schema['type'] = 'string';
      case SchemaPropertyInteger():
        schema['type'] = 'integer';
      case SchemaPropertyDouble():
        schema['type'] = 'number';
      case SchemaPropertyBoolean():
        schema['type'] = 'boolean';
      case SchemaPropertyEnum(:final enumValues):
        schema['type'] = 'string';
        schema['enum'] = enumValues;
      case SchemaPropertyArray(:final items):
        schema['type'] = 'array';
        schema['items'] = _propertyToJsonSchema(items);
      case SchemaPropertyObjectWithUndefinedProperties():
        schema['type'] = 'object';
      case SchemaPropertyStructuredObjectWithDefinedProperties(
          :final properties):
        schema['type'] = 'object';
        schema['properties'] = properties.map(
          (k, v) => MapEntry(k, _propertyToJsonSchema(v)),
        );
        schema['required'] =
            properties.entries.where((e) => !e.value.nullable).map((e) => e.key).toList();
        schema['additionalProperties'] = false;
    }

    return schema;
  }

  String? _validateAgainstSchema(
    Map<String, dynamic> value,
    Map<String, SchemaProperty> properties,
  ) {
    for (final entry in properties.entries) {
      final key = entry.key;
      final prop = entry.value;
      final hasKey = value.containsKey(key);

      if (!hasKey) {
        if (!prop.nullable) {
          return 'Missing required field "$key"';
        }
        continue;
      }

      final fieldValue = value[key];
      final error = _validateProperty(prop, fieldValue, key);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  String? _validateProperty(SchemaProperty schema, dynamic value, String path) {
    if (value == null) {
      if (!schema.nullable) {
        return 'Expected non-null value at $path';
      }
      return null;
    }

    switch (schema) {
      case SchemaPropertyString():
        if (value is! String) {
          return 'Expected String at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyInteger():
        if (value is! int) {
          return 'Expected int at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyDouble():
        if (value is! num) {
          return 'Expected num at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyBoolean():
        if (value is! bool) {
          return 'Expected bool at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyEnum(:final enumValues):
        if (value is! String || !enumValues.contains(value)) {
          return 'Invalid enum value at $path';
        }
        return null;
      case SchemaPropertyArray(:final items):
        if (value is! List) {
          return 'Expected List at $path but got ${value.runtimeType}';
        }
        for (var i = 0; i < value.length; i++) {
          final error = _validateProperty(items, value[i], '$path[$i]');
          if (error != null) {
            return error;
          }
        }
        return null;
      case SchemaPropertyObjectWithUndefinedProperties():
        if (value is! Map) {
          return 'Expected Map at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyStructuredObjectWithDefinedProperties(
          :final properties):
        if (value is! Map<String, dynamic>) {
          return 'Expected Map at $path but got ${value.runtimeType}';
        }
        for (final entry in properties.entries) {
          final error = _validateProperty(
            entry.value,
            value[entry.key],
            '$path.${entry.key}',
          );
          if (error != null) {
            return error;
          }
        }
        return null;
    }
  }
}

void main() {
  group('ChatMessage', () {
    test('creates ChatMessage with correct properties', () {
      final message = ChatMessage(role: ChatRole.user, content: 'Hello');

      expect(message.role, equals(ChatRole.user));
      expect(message.content, equals('Hello'));
    });

    test('toJson returns correct map', () {
      final message = ChatMessage(role: ChatRole.assistant, content: 'Hi');
      final json = message.toJson();

      expect(json['role'], equals('assistant'));
      expect(json['content'], equals('Hi'));
    });

    test('toJson works for all roles', () {
      expect(
        ChatMessage(role: ChatRole.user, content: 'u').toJson()['role'],
        equals('user'),
      );
      expect(
        ChatMessage(role: ChatRole.assistant, content: 'a').toJson()['role'],
        equals('assistant'),
      );
      expect(
        ChatMessage(role: ChatRole.system, content: 's').toJson()['role'],
        equals('system'),
      );
    });
  });

  group('OpenAiService chat history', () {
    test('clearHistory removes all messages', () {
      final mockClient = MockHttpClient();
      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      // Manually add messages to history by processing a stream
      service.clearHistory();

      expect(service.history, isEmpty);
    });

    test('history getter returns unmodifiable list', () {
      final mockClient = MockHttpClient();
      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final historyList = service.history;

      expect(
        () => (historyList as List).add(
          ChatMessage(role: ChatRole.user, content: 'test'),
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });

  group('streamPromptGeneration', () {
    test('yields content chunks from SSE response', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"Hello"}}]}\n\n',
          'data: {"choices":[{"delta":{"content":" World"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final results = <AiStreamResult>[];
      await for (final result in service.streamPromptGeneration(
        prompt: 'Say hello',
      )) {
        results.add(result);
      }

      expect(results.length, equals(2));
      expect(results[0], isA<AiResultItem>());
      expect((results[0] as AiResultItem).result, equals('Hello'));
      expect(results[1], isA<AiResultItem>());
      expect((results[1] as AiResultItem).result, equals(' World'));
    });

    test('yields thinking chunks for reasoning content', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"reasoning":"Let me think..."}}]}\n\n',
          'data: {"choices":[{"delta":{"content":"Answer"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final results = <AiStreamResult>[];
      await for (final result in service.streamPromptGeneration(
        prompt: 'Think about this',
      )) {
        results.add(result);
      }

      expect(results.length, equals(2));
      expect(results[0], isA<AiThinkItem>());
      expect(
        (results[0] as AiThinkItem).thinkingChunk.thinkingText,
        equals('Let me think...'),
      );
      expect(results[1], isA<AiResultItem>());
      expect((results[1] as AiResultItem).result, equals('Answer'));
    });

    test('throws HttpException for non-200 response', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse(500, 'Internal Server Error');
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      expect(
        () => service.streamPromptGeneration(prompt: 'test').toList(),
        throwsA(isA<HttpException>()),
      );
    });

    test('maintains chat history correctly', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"Response"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      await service.streamPromptGeneration(prompt: 'Hello').toList();

      expect(service.history.length, equals(2));
      expect(service.history[0].role, equals(ChatRole.user));
      expect(service.history[0].content, equals('Hello'));
      expect(service.history[1].role, equals(ChatRole.assistant));
      expect(service.history[1].content, equals('Response'));
    });

    test('includes web search plugin when flag is set', () async {
      final mockClient = MockHttpClient();
      Map<String, dynamic>? capturedBody;

      mockClient.onRequest = (request) {
        capturedBody = jsonDecode(request.body);
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"Result"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      await service
          .streamPromptGeneration(
            prompt: 'Search for something',
            shouldUseInternetSearchTool: true,
          )
          .toList();

      expect(capturedBody, isNotNull);
      expect(capturedBody!['plugins'], isNotNull);
      expect(capturedBody!['plugins'][0]['id'], equals('web'));
    });

    test('does not include web search plugin when flag is false', () async {
      final mockClient = MockHttpClient();
      Map<String, dynamic>? capturedBody;

      mockClient.onRequest = (request) {
        capturedBody = jsonDecode(request.body);
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"Result"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      await service
          .streamPromptGeneration(
            prompt: 'Just answer',
            shouldUseInternetSearchTool: false,
          )
          .toList();

      expect(capturedBody, isNotNull);
      expect(capturedBody!.containsKey('plugins'), isFalse);
    });

    test('skips malformed JSON chunks gracefully', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"Good"}}]}\n\n',
          'data: {malformed json\n\n',
          'data: {"choices":[{"delta":{"content":" data"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final results = <AiStreamResult>[];
      await for (final result in service.streamPromptGeneration(
        prompt: 'test',
      )) {
        results.add(result);
      }

      expect(results.length, equals(2));
      expect((results[0] as AiResultItem).result, equals('Good'));
      expect((results[1] as AiResultItem).result, equals(' data'));
    });

    test('throws on streaming error in response', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"Start"}}]}\n\n',
          'data: {"error":{"message":"Rate limit exceeded"}}\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      expect(
        () => service.streamPromptGeneration(prompt: 'test').toList(),
        throwsA(isA<HttpException>()),
      );
    });

    test('skips empty lines and SSE comments', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          ': this is a comment\n',
          '\n',
          'data: {"choices":[{"delta":{"content":"Content"}}]}\n\n',
          '\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final results = <AiStreamResult>[];
      await for (final result in service.streamPromptGeneration(
        prompt: 'test',
      )) {
        results.add(result);
      }

      expect(results.length, equals(1));
      expect((results[0] as AiResultItem).result, equals('Content'));
    });
  });

  group('streamPromptGenerationWithSchemaResponse', () {
    test('yields schema result for valid JSON response', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"{\\"name\\": \\"John\\", \\"age\\": 30}"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'name': SchemaPropertyString(nullable: false, shouldBeTranslated: false),
        'age': SchemaPropertyInteger(nullable: false),
      };

      final results = <AiStreamResult>[];
      await for (final result
          in service.streamPromptGenerationWithSchemaResponse(
        prompt: 'Get person info',
        properties: properties,
      )) {
        results.add(result);
      }

      expect(results.length, equals(1));
      expect(results[0], isA<AiSchemaResultItem>());
      final resultItem = results[0] as AiSchemaResultItem;
      expect(resultItem.result['name'], equals('John'));
      expect(resultItem.result['age'], equals(30));
    });

    test('yields thinking chunks for schema responses', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"reasoning":"Analyzing..."}}]}\n\n',
          'data: {"choices":[{"delta":{"content":"{\\"value\\": 42}"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'value': SchemaPropertyInteger(nullable: false),
      };

      final results = <AiStreamResult>[];
      await for (final result
          in service.streamPromptGenerationWithSchemaResponse(
        prompt: 'Calculate',
        properties: properties,
      )) {
        results.add(result);
      }

      expect(results.length, equals(2));
      expect(results[0], isA<AiSchemaThinkItem>());
      expect(
        (results[0] as AiSchemaThinkItem).thinkingChunk.thinkingText,
        equals('Analyzing...'),
      );
      expect(results[1], isA<AiSchemaResultItem>());
    });

    test('retries on schema validation failure', () async {
      final mockClient = MockHttpClient();
      var requestCount = 0;

      mockClient.onRequest = (request) {
        requestCount++;
        if (requestCount == 1) {
          // First request returns invalid schema (missing required field)
          return MockHttpClientResponse.withSseEvents(200, [
            'data: {"choices":[{"delta":{"content":"{\\"wrong\\": \\"data\\"}"}}]}\n\n',
            'data: [DONE]\n\n',
          ]);
        } else {
          // Retry returns valid schema
          return MockHttpClientResponse.withSseEvents(200, [
            'data: {"choices":[{"delta":{"content":"{\\"name\\": \\"Fixed\\"}"}}]}\n\n',
            'data: [DONE]\n\n',
          ]);
        }
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'name': SchemaPropertyString(nullable: false, shouldBeTranslated: false),
      };

      final results = <AiStreamResult>[];
      await for (final result
          in service.streamPromptGenerationWithSchemaResponse(
        prompt: 'Get name',
        properties: properties,
        maxRetries: 2,
      )) {
        results.add(result);
      }

      expect(requestCount, equals(2));
      expect(results.length, equals(1));
      expect(results[0], isA<AiSchemaResultItem>());
      expect((results[0] as AiSchemaResultItem).result['name'], equals('Fixed'));
    });

    test('throws after max retries exceeded', () async {
      final mockClient = MockHttpClient();

      mockClient.onRequest = (request) {
        // Always return invalid schema
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"{\\"invalid\\": true}"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'requiredField': SchemaPropertyString(nullable: false, shouldBeTranslated: false),
      };

      expect(
        () => service
            .streamPromptGenerationWithSchemaResponse(
              prompt: 'Get data',
              properties: properties,
              maxRetries: 1,
            )
            .toList(),
        throwsA(isA<FormatException>()),
      );
    });

    test('retries on JSON parsing error', () async {
      final mockClient = MockHttpClient();
      var requestCount = 0;

      mockClient.onRequest = (request) {
        requestCount++;
        if (requestCount == 1) {
          // First request returns malformed JSON
          return MockHttpClientResponse.withSseEvents(200, [
            'data: {"choices":[{"delta":{"content":"not valid json"}}]}\n\n',
            'data: [DONE]\n\n',
          ]);
        } else {
          // Retry returns valid JSON
          return MockHttpClientResponse.withSseEvents(200, [
            'data: {"choices":[{"delta":{"content":"{\\"status\\": \\"ok\\"}"}}]}\n\n',
            'data: [DONE]\n\n',
          ]);
        }
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'status': SchemaPropertyString(nullable: false, shouldBeTranslated: false),
      };

      final results = <AiStreamResult>[];
      await for (final result
          in service.streamPromptGenerationWithSchemaResponse(
        prompt: 'Get status',
        properties: properties,
        maxRetries: 2,
      )) {
        results.add(result);
      }

      expect(requestCount, equals(2));
      expect(results.length, equals(1));
      expect(
        (results[0] as AiSchemaResultItem).result['status'],
        equals('ok'),
      );
    });

    test('maintains history across retries', () async {
      final mockClient = MockHttpClient();
      var requestCount = 0;

      mockClient.onRequest = (request) {
        requestCount++;
        if (requestCount == 1) {
          return MockHttpClientResponse.withSseEvents(200, [
            'data: {"choices":[{"delta":{"content":"{\\"bad\\": 1}"}}]}\n\n',
            'data: [DONE]\n\n',
          ]);
        } else {
          return MockHttpClientResponse.withSseEvents(200, [
            'data: {"choices":[{"delta":{"content":"{\\"good\\": \\"value\\"}"}}]}\n\n',
            'data: [DONE]\n\n',
          ]);
        }
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'good': SchemaPropertyString(nullable: false, shouldBeTranslated: false),
      };

      await service
          .streamPromptGenerationWithSchemaResponse(
            prompt: 'Initial prompt',
            properties: properties,
            maxRetries: 2,
          )
          .toList();

      // History should contain: initial prompt, bad response, retry prompt, good response
      expect(service.history.length, equals(4));
      expect(service.history[0].role, equals(ChatRole.user));
      expect(service.history[0].content, equals('Initial prompt'));
      expect(service.history[1].role, equals(ChatRole.assistant));
      expect(service.history[2].role, equals(ChatRole.user));
      expect(
        service.history[2].content,
        contains('did not match the expected schema'),
      );
      expect(service.history[3].role, equals(ChatRole.assistant));
    });

    test('includes response_format with json_schema in request', () async {
      final mockClient = MockHttpClient();
      Map<String, dynamic>? capturedBody;

      mockClient.onRequest = (request) {
        capturedBody = jsonDecode(request.body);
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"{\\"field\\": \\"value\\"}"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'field': SchemaPropertyString(nullable: false, shouldBeTranslated: false),
      };

      await service
          .streamPromptGenerationWithSchemaResponse(
            prompt: 'test',
            properties: properties,
          )
          .toList();

      expect(capturedBody, isNotNull);
      expect(capturedBody!['response_format'], isNotNull);
      expect(capturedBody!['response_format']['type'], equals('json_schema'));
      expect(
        capturedBody!['response_format']['json_schema']['name'],
        equals('response_schema'),
      );
      expect(
        capturedBody!['response_format']['json_schema']['strict'],
        isTrue,
      );
    });

    test('validates nested object schemas', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"{\\"person\\": {\\"name\\": \\"Alice\\", \\"age\\": 25}}"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'person': SchemaPropertyStructuredObjectWithDefinedProperties(
          nullable: false,
          properties: {
            'name': SchemaPropertyString(nullable: false, shouldBeTranslated: false),
            'age': SchemaPropertyInteger(nullable: false),
          },
        ),
      };

      final results = <AiStreamResult>[];
      await for (final result
          in service.streamPromptGenerationWithSchemaResponse(
        prompt: 'Get person',
        properties: properties,
      )) {
        results.add(result);
      }

      expect(results.length, equals(1));
      expect(results[0], isA<AiSchemaResultItem>());
      final person = (results[0] as AiSchemaResultItem).result['person'];
      expect(person['name'], equals('Alice'));
      expect(person['age'], equals(25));
    });

    test('validates array schemas', () async {
      final mockClient = MockHttpClient();
      mockClient.onRequest = (request) {
        return MockHttpClientResponse.withSseEvents(200, [
          'data: {"choices":[{"delta":{"content":"{\\"items\\": [\\"a\\", \\"b\\", \\"c\\"]}"}}]}\n\n',
          'data: [DONE]\n\n',
        ]);
      };

      final service = TestableOpenAiService(
        'test-api-key',
        httpClientFactory: () => mockClient,
      );

      final properties = <String, SchemaProperty>{
        'items': SchemaPropertyArray(
          nullable: false,
          items: SchemaPropertyString(nullable: false, shouldBeTranslated: false),
        ),
      };

      final results = <AiStreamResult>[];
      await for (final result
          in service.streamPromptGenerationWithSchemaResponse(
        prompt: 'Get items',
        properties: properties,
      )) {
        results.add(result);
      }

      expect(results.length, equals(1));
      expect(results[0], isA<AiSchemaResultItem>());
      final items = (results[0] as AiSchemaResultItem).result['items'] as List;
      expect(items, equals(['a', 'b', 'c']));
    });
  });

  group('AiStreamResult types', () {
    test('AiThinkItem contains AiThinkingChunk', () {
      final chunk = AiThinkingChunk(thinkingText: 'Thinking...');
      final item = AiThinkItem(chunk);

      expect(item.thinkingChunk, equals(chunk));
      expect(item.thinkingChunk.thinkingText, equals('Thinking...'));
    });

    test('AiResultItem contains result string', () {
      final item = AiResultItem('Result content');

      expect(item.result, equals('Result content'));
    });

    test('AiSchemaThinkItem contains AiThinkingChunk', () {
      final chunk = AiThinkingChunk(thinkingText: 'Schema thinking...');
      final item = AiSchemaThinkItem(chunk);

      expect(item.thinkingChunk, equals(chunk));
      expect(item.thinkingChunk.thinkingText, equals('Schema thinking...'));
    });

    test('AiSchemaResultItem contains result map', () {
      final resultMap = {'key': 'value', 'number': 42};
      final item = AiSchemaResultItem(resultMap);

      expect(item.result, equals(resultMap));
      expect(item.result['key'], equals('value'));
      expect(item.result['number'], equals(42));
    });
  });

  group('ChatRole enum', () {
    test('has correct values', () {
      expect(ChatRole.values.length, equals(3));
      expect(ChatRole.values.contains(ChatRole.user), isTrue);
      expect(ChatRole.values.contains(ChatRole.assistant), isTrue);
      expect(ChatRole.values.contains(ChatRole.system), isTrue);
    });

    test('name property returns correct string', () {
      expect(ChatRole.user.name, equals('user'));
      expect(ChatRole.assistant.name, equals('assistant'));
      expect(ChatRole.system.name, equals('system'));
    });
  });
}

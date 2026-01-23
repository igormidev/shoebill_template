import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/utils/consts.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

/// Message role for chat history
enum ChatRole { user, assistant, system }

/// Represents a message in the chat history
class AiChatMessage {
  final ChatRole role;
  final String content;

  const AiChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
    'role': role.name,
    'content': content,
  };
}

/// Factory function type for creating OpenAiService instances
typedef OpenAiServiceFactory = OpenAiService Function();

/// Interface for AI service operations
abstract interface class IOpenAiService {
  /// Generates a prompt response (stateless, no history)
  Future<String> generatePrompt({String model, required String prompt});

  /// Translates texts (stateless, no history)
  Future<Map<String, String>> translateTexts({
    required Map<String, String> textsToTranslate,
    required String sourceLanguage,
    required String targetLanguage,
    String? model,
  });

  /// Streams prompt generation with chat history support
  Stream<AiStreamResult> streamPromptGeneration({
    required String prompt,
    bool shouldUseInternetSearchTool = false,
    String? model,
  });

  /// Streams prompt generation with schema response and validation.
  /// Automatically validates the response against the schema and retries if needed.
  Stream<AiStreamResult> streamPromptGenerationWithSchemaResponse({
    required String prompt,
    required Map<String, SchemaProperty> properties,
    bool shouldUseInternetSearchTool = false,
    String? model,
    int maxRetries = kAiServiceDefaultRetryCount,
  });

  /// Clears the chat history for this instance
  void clearHistory();

  /// Gets the current chat history
  List<AiChatMessage> get history;
}

abstract class AiStreamResult {}

class AiThinkItem extends AiStreamResult {
  final AiThinkingChunk thinkingChunk;
  AiThinkItem(this.thinkingChunk);
}

class AiResultItem extends AiStreamResult {
  final String result;
  AiResultItem(this.result);
}

class AiSchemaThinkItem extends AiStreamResult {
  final AiThinkingChunk thinkingChunk;
  AiSchemaThinkItem(this.thinkingChunk);
}

class AiSchemaResultItem extends AiStreamResult {
  final Map<String, dynamic> result;
  AiSchemaResultItem(this.result);
}

/// Represents a parsed SSE delta with optional thinking and content chunks.
class _ParsedDelta {
  final List<AiThinkingChunk> thinkingChunks;
  final String? content;

  const _ParsedDelta({required this.thinkingChunks, this.content});
}

/// OpenAI service implementation with per-instance chat history
class OpenAiService implements IOpenAiService {
  final String _apiKey;

  /// Reusable HTTP client for all requests made by this service instance.
  final HttpClient _httpClient = HttpClient();

  /// Chat history for this instance
  final List<AiChatMessage> _history = [];

  OpenAiService(this._apiKey);

  static const _defaultModel = kDefaultAiModel;

  @override
  List<AiChatMessage> get history => List.unmodifiable(_history);

  @override
  void clearHistory() {
    _history.clear();
  }

  /// Closes the underlying HTTP client. Call when this service is no longer needed.
  void dispose() {
    _httpClient.close();
  }

  /// Adds a message to the history
  void _addToHistory(ChatRole role, String content) {
    _history.add(AiChatMessage(role: role, content: content));
  }

  // ===========================================================================
  // SSE Parsing Utilities
  // ===========================================================================

  /// Processes raw SSE chunks from an HTTP response stream and yields
  /// individual parsed JSON event maps. Handles line buffering, skips
  /// comments/empty lines, and detects the `[DONE]` sentinel.
  ///
  /// The [onDone] callback is invoked when the `data: [DONE]` line is received,
  /// allowing the caller to perform finalization before the stream ends.
  Stream<Map<String, dynamic>> _parseSseStream(
    HttpClientResponse response, {
    Future<void> Function()? onDone,
  }) async* {
    final lineBuffer = StringBuffer();

    await for (final chunk in response.transform(utf8.decoder)) {
      lineBuffer.write(chunk);
      final bufferContent = lineBuffer.toString();
      final lines = bufferContent.split('\n');

      // Keep incomplete last line in buffer
      lineBuffer.clear();
      if (!bufferContent.endsWith('\n')) {
        lineBuffer.write(lines.removeLast());
      }

      for (final line in lines) {
        final trimmedLine = line.trim();

        // Skip empty lines and SSE comments
        if (trimmedLine.isEmpty || trimmedLine.startsWith(':')) {
          continue;
        }

        // Check for stream end
        if (trimmedLine == 'data: [DONE]') {
          await onDone?.call();
          return;
        }

        // Parse SSE data
        if (trimmedLine.startsWith('data: ')) {
          final jsonStr = trimmedLine.substring(6);
          try {
            final json = jsonDecode(jsonStr) as Map<String, dynamic>;

            // Check for error in stream
            if (json.containsKey('error')) {
              final error = json['error'];
              throw ShoebillException(
                title: 'OpenRouter streaming error',
                description:
                    'Error received during streaming: ${jsonEncode(error)}',
              );
            }

            yield json;
          } on FormatException {
            // Skip malformed JSON chunks
            continue;
          }
        }
      }
    }
  }

  /// Extracts the delta from a parsed SSE JSON event, returning thinking
  /// chunks and content text. Returns `null` if the event has no usable delta.
  _ParsedDelta? _extractDelta(Map<String, dynamic> json) {
    final choices = json['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) return null;

    final delta = choices[0]['delta'] as Map<String, dynamic>?;
    if (delta == null) return null;

    final thinkingChunks = <AiThinkingChunk>[];

    // Check for reasoning/thinking content
    final reasoning = delta['reasoning'] as String?;
    if (reasoning != null && reasoning.isNotEmpty) {
      thinkingChunks.add(AiThinkingChunk(thinkingText: reasoning));
    }

    // Check for reasoning_details array (newer format)
    final reasoningDetails = delta['reasoning_details'] as List<dynamic>?;
    if (reasoningDetails != null) {
      for (final detail in reasoningDetails) {
        if (detail is Map<String, dynamic>) {
          final text = detail['text'] as String?;
          final summary = detail['summary'] as String?;
          final thinkingText = text ?? summary;
          if (thinkingText != null && thinkingText.isNotEmpty) {
            thinkingChunks.add(AiThinkingChunk(thinkingText: thinkingText));
          }
        }
      }
    }

    // Extract regular content
    final content = delta['content'] as String?;

    return _ParsedDelta(
      thinkingChunks: thinkingChunks,
      content: (content != null && content.isNotEmpty) ? content : null,
    );
  }

  /// Prepares an [HttpClientRequest] to the OpenRouter API with standard
  /// headers (Authorization, Content-Type) already set.
  Future<HttpClientRequest> _createApiRequest() async {
    final request = await _httpClient.postUrl(
      Uri.parse(kOpenRouterApiUrl),
    );
    request.headers.set('Authorization', 'Bearer $_apiKey');
    request.headers.set('Content-Type', 'application/json');
    return request;
  }

  // ===========================================================================
  // Public API Implementations
  // ===========================================================================

  @override
  Future<String> generatePrompt({
    String model = _defaultModel,
    required String prompt,
  }) async {
    return _callOpenRouter(model: model, prompt: prompt);
  }

  /// Translates a map of key-value pairs from source language to target language.
  /// Returns a map with the same keys but translated values.
  /// Keys are JSON paths (e.g., "root.title", "root.items[0].name").
  @override
  Future<Map<String, String>> translateTexts({
    required Map<String, String> textsToTranslate,
    required String sourceLanguage,
    required String targetLanguage,
    String? model,
  }) async {
    final effectiveModel = model ?? _defaultModel;
    if (textsToTranslate.isEmpty) {
      return {};
    }

    final inputJson = jsonEncode(textsToTranslate);
    final prompt =
        '''
You are a professional translator. Translate the following JSON object's values from $sourceLanguage to $targetLanguage.

IMPORTANT RULES:
1. Only translate the VALUES, keep the keys exactly the same
2. Preserve any formatting, placeholders (like {name}, {{value}}, %s, etc.)
3. Maintain the same JSON structure
4. Return ONLY valid JSON, no explanations or markdown

Input JSON:
$inputJson

Return the translated JSON:''';

    final response = await _callOpenRouter(
      model: effectiveModel,
      prompt: prompt,
    );

    // Parse the response as JSON
    try {
      final decoded = jsonDecode(response.trim());
      if (decoded is Map<String, dynamic>) {
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      }
      throw ShoebillException(
        title: 'Invalid translation response format',
        description: 'Expected JSON object, got: ${decoded.runtimeType}',
      );
    } catch (e) {
      throw ShoebillException(
        title: 'Translation response parsing failed',
        description: 'Failed to parse translation response as JSON: $e\nResponse was: $response',
      );
    }
  }

  Future<String> _callOpenRouter({
    required String model,
    required String prompt,
  }) async {
    final request = await _createApiRequest();

    final body = jsonEncode({
      'model': model,
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
    });

    request.write(body);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      throw ShoebillException(
        title: 'OpenRouter API error',
        description: 'Request failed with status ${response.statusCode}: $responseBody',
      );
    }

    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final choices = json['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw ShoebillException(
        title: 'Invalid OpenRouter response',
        description: 'No choices in OpenRouter response: $responseBody',
      );
    }

    final message = choices[0]['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;
    if (content == null) {
      throw ShoebillException(
        title: 'Invalid OpenRouter response',
        description: 'No content in OpenRouter response: $responseBody',
      );
    }

    return content;
  }

  @override
  Stream<AiStreamResult> streamPromptGeneration({
    required String prompt,
    bool shouldUseInternetSearchTool = false,
    String? model,
  }) async* {
    final effectiveModel = model ?? _defaultModel;

    // Add user message to history
    _addToHistory(ChatRole.user, prompt);

    final contentBuffer = StringBuffer();

    final request = await _createApiRequest();

    // Build messages from history
    final messages = _history.map((m) => m.toJson()).toList();

    final body = <String, dynamic>{
      'model': effectiveModel,
      'stream': true,
      'messages': messages,
    };

    // Add web search plugin if requested
    if (shouldUseInternetSearchTool) {
      body['plugins'] = [
        {'id': 'web'},
      ];
    }

    request.write(jsonEncode(body));

    final response = await request.close();

    if (response.statusCode != 200) {
      final errorBody = await response.transform(utf8.decoder).join();
      throw ShoebillException(
        title: 'OpenRouter API error',
        description: 'Streaming request failed with status ${response.statusCode}: $errorBody',
      );
    }

    // Process SSE stream using shared parser
    var doneCallbackFired = false;
    await for (final json in _parseSseStream(response, onDone: () async {
      doneCallbackFired = true;
      if (contentBuffer.isNotEmpty) {
        _addToHistory(ChatRole.assistant, contentBuffer.toString());
      }
    })) {
      final parsed = _extractDelta(json);
      if (parsed == null) continue;

      for (final chunk in parsed.thinkingChunks) {
        yield AiThinkItem(chunk);
      }

      if (parsed.content != null) {
        contentBuffer.write(parsed.content);
        yield AiResultItem(parsed.content!);
      }
    }

    // Only add if stream ended without [DONE]
    if (!doneCallbackFired && contentBuffer.isNotEmpty) {
      _addToHistory(ChatRole.assistant, contentBuffer.toString());
    }
  }

  @override
  Stream<AiStreamResult> streamPromptGenerationWithSchemaResponse({
    required String prompt,
    required Map<String, SchemaProperty> properties,
    bool shouldUseInternetSearchTool = false,
    String? model,
    int maxRetries = kAiServiceDefaultRetryCount,
  }) async* {
    yield* _streamWithSchemaAndValidation(
      prompt: prompt,
      properties: properties,
      shouldUseInternetSearchTool: shouldUseInternetSearchTool,
      model: model,
      retriesRemaining: maxRetries,
    );
  }

  Stream<AiStreamResult> _streamWithSchemaAndValidation({
    required String prompt,
    required Map<String, SchemaProperty> properties,
    required bool shouldUseInternetSearchTool,
    required String? model,
    required int retriesRemaining,
  }) async* {
    final effectiveModel = model ?? _defaultModel;

    // Add user message to history
    _addToHistory(ChatRole.user, prompt);

    final request = await _createApiRequest();

    // Build messages from history
    final messages = _history.map((m) => m.toJson()).toList();

    // Build JSON Schema for OpenRouter structured output
    final jsonSchema = properties.toOpenRouterJsonSchema();

    final body = <String, dynamic>{
      'model': effectiveModel,
      'stream': true,
      'messages': messages,
      'response_format': {
        'type': 'json_schema',
        'json_schema': {
          'name': 'response_schema',
          'strict': true,
          'schema': jsonSchema,
        },
      },
    };

    // Add web search plugin if requested
    if (shouldUseInternetSearchTool) {
      body['plugins'] = [
        {'id': 'web'},
      ];
    }

    request.write(jsonEncode(body));

    final response = await request.close();

    if (response.statusCode != 200) {
      final errorBody = await response.transform(utf8.decoder).join();
      throw ShoebillException(
        title: 'OpenRouter API error',
        description: 'Schema streaming request failed with status ${response.statusCode}: $errorBody',
      );
    }

    // Process SSE stream and accumulate JSON content
    final contentBuffer = StringBuffer();

    await for (final json in _parseSseStream(response)) {
      final parsed = _extractDelta(json);
      if (parsed == null) continue;

      for (final chunk in parsed.thinkingChunks) {
        yield AiSchemaThinkItem(chunk);
      }

      if (parsed.content != null) {
        contentBuffer.write(parsed.content);
      }
    }

    // Finalize: parse accumulated content and validate against schema
    final fullContent = contentBuffer.toString().trim();
    if (fullContent.isNotEmpty) {
      _addToHistory(ChatRole.assistant, fullContent);

      yield* _validateAndYieldSchemaResult(
        fullContent: fullContent,
        properties: properties,
        shouldUseInternetSearchTool: shouldUseInternetSearchTool,
        model: model,
        retriesRemaining: retriesRemaining,
      );
    }
  }

  /// Parses the accumulated content as JSON, validates it against the schema,
  /// and either yields the result or retries on failure.
  Stream<AiStreamResult> _validateAndYieldSchemaResult({
    required String fullContent,
    required Map<String, SchemaProperty> properties,
    required bool shouldUseInternetSearchTool,
    required String? model,
    required int retriesRemaining,
  }) async* {
    try {
      final parsed = jsonDecode(fullContent) as Map<String, dynamic>;

      // Validate against schema
      final schemaObj = SchemaPropertyStructuredObjectWithDefinedProperties(
        nullable: false,
        properties: properties,
      );
      final validationError =
          schemaObj.validateJsonFollowsSchemaStructure(parsed);

      if (validationError != null) {
        if (retriesRemaining > 0) {
          yield* _retryWithValidationError(
            validationError: validationError,
            properties: properties,
            shouldUseInternetSearchTool: shouldUseInternetSearchTool,
            model: model,
            retriesRemaining: retriesRemaining - 1,
          );
          return;
        } else {
          throw ShoebillException(
            title: 'Schema validation failed',
            description:
                'Schema validation failed after retries: $validationError',
          );
        }
      }

      yield AiSchemaResultItem(parsed);
    } on FormatException catch (e) {
      if (retriesRemaining > 0) {
        yield* _retryWithValidationError(
          validationError: 'JSON parsing error: $e',
          properties: properties,
          shouldUseInternetSearchTool: shouldUseInternetSearchTool,
          model: model,
          retriesRemaining: retriesRemaining - 1,
        );
        return;
      }
      throw ShoebillException(
        title: 'JSON response parsing failed',
        description:
            'Failed to parse final JSON response: $e\nContent was: $fullContent',
      );
    }
  }

  /// Retries the schema request with a follow-up message explaining the validation error
  Stream<AiStreamResult> _retryWithValidationError({
    required String validationError,
    required Map<String, SchemaProperty> properties,
    required bool shouldUseInternetSearchTool,
    required String? model,
    required int retriesRemaining,
  }) async* {
    final retryPrompt =
        '''
Your previous response did not match the expected schema. Here is the validation error:

$validationError

Please provide a corrected response that matches the exact schema requirements. Ensure all required fields are present and have the correct types.''';

    yield* _streamWithSchemaAndValidation(
      prompt: retryPrompt,
      properties: properties,
      shouldUseInternetSearchTool: shouldUseInternetSearchTool,
      model: model,
      retriesRemaining: retriesRemaining,
    );
  }
}

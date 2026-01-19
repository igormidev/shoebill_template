import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

/// Message role for chat history
enum ChatRole { user, assistant, system }

/// Represents a message in the chat history
class ChatMessage {
  final ChatRole role;
  final String content;

  const ChatMessage({required this.role, required this.content});

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
    int maxRetries = 2,
  });

  /// Clears the chat history for this instance
  void clearHistory();

  /// Gets the current chat history
  List<ChatMessage> get history;
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

abstract class AiStreamSchemaResult {}

class AiSchemaThinkItem extends AiStreamResult {
  final AiThinkingChunk thinkingChunk;
  AiSchemaThinkItem(this.thinkingChunk);
}

class AiSchemaResultItem extends AiStreamResult {
  final Map<String, dynamic> result;
  AiSchemaResultItem(this.result);
}

/// OpenAI service implementation with per-instance chat history
class OpenAiService implements IOpenAiService {
  final String _apiKey;

  /// Chat history for this instance
  final List<ChatMessage> _history = [];

  OpenAiService(this._apiKey);

  static const _defaultModel = 'openai/gpt-4.1-mini';

  @override
  List<ChatMessage> get history => List.unmodifiable(_history);

  @override
  void clearHistory() {
    _history.clear();
  }

  /// Adds a message to the history
  void _addToHistory(ChatRole role, String content) {
    _history.add(ChatMessage(role: role, content: content));
  }

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
    final prompt = '''
You are a professional translator. Translate the following JSON object's values from $sourceLanguage to $targetLanguage.

IMPORTANT RULES:
1. Only translate the VALUES, keep the keys exactly the same
2. Preserve any formatting, placeholders (like {name}, {{value}}, %s, etc.)
3. Maintain the same JSON structure
4. Return ONLY valid JSON, no explanations or markdown

Input JSON:
$inputJson

Return the translated JSON:''';

    final response = await _callOpenRouter(model: effectiveModel, prompt: prompt);

    // Parse the response as JSON
    try {
      final decoded = jsonDecode(response.trim());
      if (decoded is Map<String, dynamic>) {
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      }
      throw FormatException(
        'Expected JSON object, got: ${decoded.runtimeType}',
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse translation response as JSON: $e\nResponse was: $response',
      );
    }
  }

  Future<String> _callOpenRouter({
    required String model,
    required String prompt,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      );

      request.headers.set('Authorization', 'Bearer $_apiKey');
      request.headers.set('Content-Type', 'application/json');

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
        throw HttpException(
          'OpenRouter API error: ${response.statusCode} - $responseBody',
        );
      }

      final json = jsonDecode(responseBody) as Map<String, dynamic>;
      final choices = json['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw FormatException(
          'No choices in OpenRouter response: $responseBody',
        );
      }

      final message = choices[0]['message'] as Map<String, dynamic>?;
      final content = message?['content'] as String?;
      if (content == null) {
        throw FormatException(
          'No content in OpenRouter response: $responseBody',
        );
      }

      return content;
    } finally {
      client.close();
    }
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

    final client = HttpClient();
    final contentBuffer = StringBuffer();

    try {
      final request = await client.postUrl(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      );

      request.headers.set('Authorization', 'Bearer $_apiKey');
      request.headers.set('Content-Type', 'application/json');

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
            // Add assistant response to history
            if (contentBuffer.isNotEmpty) {
              _addToHistory(ChatRole.assistant, contentBuffer.toString());
            }
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
                throw HttpException(
                  'OpenRouter streaming error: ${jsonEncode(error)}',
                );
              }

              final choices = json['choices'] as List<dynamic>?;
              if (choices == null || choices.isEmpty) continue;

              final delta = choices[0]['delta'] as Map<String, dynamic>?;
              if (delta == null) continue;

              // Check for reasoning/thinking content
              final reasoning = delta['reasoning'] as String?;
              if (reasoning != null && reasoning.isNotEmpty) {
                yield AiThinkItem(AiThinkingChunk(thinkingText: reasoning));
              }

              // Check for reasoning_details array (newer format)
              final reasoningDetails =
                  delta['reasoning_details'] as List<dynamic>?;
              if (reasoningDetails != null) {
                for (final detail in reasoningDetails) {
                  if (detail is Map<String, dynamic>) {
                    final text = detail['text'] as String?;
                    final summary = detail['summary'] as String?;
                    final thinkingText = text ?? summary;
                    if (thinkingText != null && thinkingText.isNotEmpty) {
                      yield AiThinkItem(
                        AiThinkingChunk(thinkingText: thinkingText),
                      );
                    }
                  }
                }
              }

              // Check for regular content
              final content = delta['content'] as String?;
              if (content != null && content.isNotEmpty) {
                contentBuffer.write(content);
                yield AiResultItem(content);
              }
            } on FormatException {
              // Skip malformed JSON chunks
              continue;
            }
          }
        }
      }

      // Add final response to history if stream ended without [DONE]
      if (contentBuffer.isNotEmpty) {
        _addToHistory(ChatRole.assistant, contentBuffer.toString());
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

    final client = HttpClient();

    try {
      final request = await client.postUrl(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      );

      request.headers.set('Authorization', 'Bearer $_apiKey');
      request.headers.set('Content-Type', 'application/json');

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
        throw HttpException(
          'OpenRouter API error: ${response.statusCode} - $errorBody',
        );
      }

      // Process SSE stream and accumulate JSON content
      final lineBuffer = StringBuffer();
      final contentBuffer = StringBuffer();

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
            final fullContent = contentBuffer.toString().trim();

            // Add assistant response to history
            if (fullContent.isNotEmpty) {
              _addToHistory(ChatRole.assistant, fullContent);
            }

            // Parse and validate the response
            if (fullContent.isNotEmpty) {
              try {
                final parsed = jsonDecode(fullContent) as Map<String, dynamic>;

                // Validate against schema
                final schemaObj =
                    SchemaPropertyStructuredObjectWithDefinedProperties(
                  nullable: false,
                  properties: properties,
                );
                final validationError =
                    schemaObj.validateJsonFollowsSchemaStructure(parsed);

                if (validationError != null) {
                  // Schema validation failed - retry if we have retries remaining
                  if (retriesRemaining > 0) {
                    // Add error message and retry
                    yield* _retryWithValidationError(
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
                  yield* _retryWithValidationError(
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

          // Parse SSE data
          if (trimmedLine.startsWith('data: ')) {
            final jsonStr = trimmedLine.substring(6);
            try {
              final json = jsonDecode(jsonStr) as Map<String, dynamic>;

              // Check for error in stream
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

              // Check for reasoning/thinking content
              final reasoning = delta['reasoning'] as String?;
              if (reasoning != null && reasoning.isNotEmpty) {
                yield AiSchemaThinkItem(
                  AiThinkingChunk(thinkingText: reasoning),
                );
              }

              // Check for reasoning_details array (newer format)
              final reasoningDetails =
                  delta['reasoning_details'] as List<dynamic>?;
              if (reasoningDetails != null) {
                for (final detail in reasoningDetails) {
                  if (detail is Map<String, dynamic>) {
                    final text = detail['text'] as String?;
                    final summary = detail['summary'] as String?;
                    final thinkingText = text ?? summary;
                    if (thinkingText != null && thinkingText.isNotEmpty) {
                      yield AiSchemaThinkItem(
                        AiThinkingChunk(thinkingText: thinkingText),
                      );
                    }
                  }
                }
              }

              // Accumulate content for final JSON parsing
              final content = delta['content'] as String?;
              if (content != null) {
                contentBuffer.write(content);
              }
            } on FormatException {
              // Skip malformed JSON chunks
              continue;
            }
          }
        }
      }

      // If we exit the loop without [DONE], try to parse accumulated content
      final fullContent = contentBuffer.toString().trim();
      if (fullContent.isNotEmpty) {
        _addToHistory(ChatRole.assistant, fullContent);

        try {
          final parsed = jsonDecode(fullContent) as Map<String, dynamic>;

          // Validate against schema
          final schemaObj =
              SchemaPropertyStructuredObjectWithDefinedProperties(
            nullable: false,
            properties: properties,
          );
          final validationError =
              schemaObj.validateJsonFollowsSchemaStructure(parsed);

          if (validationError != null && retriesRemaining > 0) {
            yield* _retryWithValidationError(
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
            yield* _retryWithValidationError(
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

  /// Retries the schema request with a follow-up message explaining the validation error
  Stream<AiStreamResult> _retryWithValidationError({
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

    yield* _streamWithSchemaAndValidation(
      prompt: retryPrompt,
      properties: properties,
      shouldUseInternetSearchTool: shouldUseInternetSearchTool,
      model: model,
      retriesRemaining: retriesRemaining,
    );
  }
}

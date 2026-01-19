import 'dart:convert';
import 'dart:io';

import 'package:shoebill_template_server/src/generated/protocol.dart';

abstract interface class IOpenAiService {
  Future<String> generatePrompt({String model, required String prompt});

  Future<Map<String, String>> translateTexts({
    required Map<String, String> textsToTranslate,
    required String sourceLanguage,
    required String targetLanguage,
    String? model,
  });

  Stream<AiStreamResult> streamPromptGeneration({
    required String prompt,
    bool shouldUseInternetSearchTool = false,
    String? model,
  });

  Stream<AiStreamResult> streamPromptGenerationWithSchemaResponse({
    required String prompt,
    required Map<String, SchemaProperty> properties,
    bool shouldUseInternetSearchTool = false,
    String? model,
  });
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

class OpenAiService implements IOpenAiService {
  final String _apiKey;
  const OpenAiService(this._apiKey);

  static const _defaultModel = 'openai/gpt-4.1-mini';

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
    String? model = _defaultModel,
  }) async {
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

    final response = await _callOpenRouter(model: model, prompt: prompt);

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
}

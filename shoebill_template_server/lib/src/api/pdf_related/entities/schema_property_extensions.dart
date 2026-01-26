import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/core/utils/consts.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/ai_services.dart';

/// The initial path segment used when recursively descending into JSON
/// structures for validation, translation extraction, and translation application.
const String _kRootPath = 'root';

/// A reusable JSON encoder that produces human-readable output with
/// two-space indentation.
final _kPrettyJsonEncoder = JsonEncoder.withIndent('  ');

/// Gets the global OpenAiService instance.
IOpenAiService _getOpenAiService() => GetIt.instance<IOpenAiService>();

/// Extension to provide `type` getter and custom JSON serialization for SchemaProperty
extension SchemaPropertyExtension on SchemaProperty {
  /// Returns the type string based on the runtime type
  String get type {
    return switch (this) {
      SchemaPropertyString() => 'string',
      SchemaPropertyInteger() => 'integer',
      SchemaPropertyDouble() => 'double',
      SchemaPropertyBoolean() => 'boolean',
      SchemaPropertyEnum() => 'enum',
      SchemaPropertyArray() => 'array',
      SchemaPropertyObjectWithUndefinedProperties() =>
        'dynamic_object_with_undefined_properties',
      SchemaPropertyStructuredObjectWithDefinedProperties() =>
        'structured_object_with_defined_properties',
    };
  }

  /// Converts the SchemaProperty to a JSON map with the `type` field
  Map<String, dynamic> toSchemaJson() {
    final Map<String, dynamic> json = {
      'type': type,
      'nullable': nullable,
      if (description != null) 'description': description,
    };

    switch (this) {
      case SchemaPropertyString(:final shouldBeTranslated):
        if (shouldBeTranslated) {
          json['shouldBeTranslated'] = true;
        }
      case SchemaPropertyEnum(:final enumValues):
        json['possibleEnumValues'] = enumValues;
      case SchemaPropertyArray(:final items):
        json['items'] = items.toSchemaJson();
      case SchemaPropertyStructuredObjectWithDefinedProperties(
        :final properties,
      ):
        json['properties'] = properties.map(
          (key, value) => MapEntry(key, value.toSchemaJson()),
        );
      default:
        // No additional fields for other types
        break;
    }
    return json;
  }

  /// Returns a formatted JSON string representation
  String toSchemaString() => _kPrettyJsonEncoder.convert(toSchemaJson());
}

/// Static methods for SchemaProperty that can't be in extension
class SchemaPropertyParser {
  /// Creates a SchemaProperty from a JSON map
  static SchemaProperty fromJson(Map<String, dynamic> json) {
    final rawType = json['type'];
    if (rawType == null || rawType is! String) {
      throw ShoebillException(
        title: 'Invalid schema property JSON',
        description:
            'Expected "type" to be a non-null String, but got: $rawType',
      );
    }
    final type = rawType;

    final rawNullable = json['nullable'];
    if (rawNullable == null || rawNullable is! bool) {
      throw ShoebillException(
        title: 'Invalid schema property JSON',
        description:
            'Expected "nullable" to be a non-null bool, but got: $rawNullable',
      );
    }
    final nullable = rawNullable;

    final description = json['description'] as String?;

    try {
      switch (type) {
        case 'string':
          return SchemaPropertyString(
            nullable: nullable,
            description: description,
            shouldBeTranslated: json['shouldBeTranslated'] as bool? ?? false,
          );
        case 'integer':
          return SchemaPropertyInteger(
            nullable: nullable,
            description: description,
          );
        case 'double':
          return SchemaPropertyDouble(
            nullable: nullable,
            description: description,
          );
        case 'boolean':
          return SchemaPropertyBoolean(
            nullable: nullable,
            description: description,
          );
        case 'enum':
          final rawEnumValues = json['possibleEnumValues'];
          if (rawEnumValues == null || rawEnumValues is! List<dynamic>) {
            throw ShoebillException(
              title: 'Invalid schema property JSON',
              description:
                  'Expected "possibleEnumValues" to be a non-null List '
                  'for enum type, but got: $rawEnumValues',
            );
          }
          final enumValues = rawEnumValues.map((e) => e as String).toList();
          return SchemaPropertyEnum(
            enumValues: enumValues,
            nullable: nullable,
            description: description,
          );
        case 'array':
          final items = fromJson(json['items'] as Map<String, dynamic>);
          return SchemaPropertyArray(
            items: items,
            nullable: nullable,
            description: description,
          );
        case 'dynamic_object_with_undefined_properties':
          return SchemaPropertyObjectWithUndefinedProperties(
            nullable: nullable,
            description: description,
          );
        case 'structured_object_with_defined_properties':
          final propertiesJson = json['properties'] as Map<String, dynamic>;
          final properties = propertiesJson.map(
            (key, value) => MapEntry(
              key,
              fromJson(value as Map<String, dynamic>),
            ),
          );
          return SchemaPropertyStructuredObjectWithDefinedProperties(
            properties: properties,
            nullable: nullable,
            description: description,
          );
        default:
          throw ShoebillException(
            title: 'Unknown schema property type',
            description: 'Unknown SchemaProperty type: $type',
          );
      }
    } on ShoebillException {
      rethrow;
    } catch (e) {
      throw ShoebillException(
        title: 'Failed to parse schema property',
        description:
            'Error parsing SchemaProperty of type "$type" from JSON: $e',
      );
    }
  }
}

extension SchemaDefinitionExt on SchemaDefinition {
  String? validateJsonFollowsSchemaStructure(Map<String, dynamic> model) {
    return SchemaPropertyStructuredObjectWithDefinedProperties(
      nullable: false,
      properties: properties,
    ).validateJsonFollowsSchemaStructure(model);
  }

  /// Translates all strings marked with `shouldBeTranslated: true` in the JSON
  /// using AI-powered translation via OpenRouter.
  ///
  /// When the number of translatable strings exceeds [kTranslationBatchSize],
  /// the strings are split into multiple chunks and translated in parallel
  /// using [Future.wait]. This significantly reduces total translation time
  /// for payloads with many translatable fields, as each chunk is sent as a
  /// separate API request and all chunks are processed concurrently.
  ///
  /// Throws [ShoebillException] if the JSON is invalid or translation fails.
  Future<String> translateBasedOnSchema({
    required String stringifiedJson,
    required SupportedLanguage sourceLanguage,
    required SupportedLanguage targetLanguage,
  }) async {
    final sourceJson = tryDecode(stringifiedJson);
    if (sourceJson == null) {
      throw ShoebillException(
        title: 'Invalid JSON',
        description: 'The provided string is not valid JSON.',
      );
    }

    // Extract all translatable strings with their paths
    final translatableStrings = <String, String>{};
    _extractTranslatableStrings(
      schema: toSchemaProperty(),
      value: sourceJson,
      path: _kRootPath,
      result: translatableStrings,
    );

    if (translatableStrings.isEmpty) {
      // No strings to translate, return original
      return stringifiedJson;
    }

    final openAiService = _getOpenAiService();
    final sourceDisplayName = _languageToDisplayName(sourceLanguage);
    final targetDisplayName = _languageToDisplayName(targetLanguage);

    // Translate strings in parallel batches for improved performance.
    // If the total count is within a single batch, only one API call is made.
    // Otherwise, the map is chunked and all chunks are sent concurrently.
    final Map<String, String> translatedStrings;
    try {
      translatedStrings = await _translateInParallelBatches(
        openAiService: openAiService,
        textsToTranslate: translatableStrings,
        sourceLanguage: sourceDisplayName,
        targetLanguage: targetDisplayName,
      );
    } catch (e) {
      throw ShoebillException(
        title: 'Translation API error',
        description: 'Failed to translate content: $e',
      );
    }

    // Reconstruct the JSON with translated values
    final targetJson = _applyTranslations(
      schema: toSchemaProperty(),
      value: sourceJson,
      path: _kRootPath,
      translations: translatedStrings,
    );

    return _kPrettyJsonEncoder.convert(targetJson);
  }
}

/// Helper to extract all translatable strings from JSON based on schema.
void _extractTranslatableStrings({
  required SchemaProperty schema,
  required Object? value,
  required String path,
  required Map<String, String> result,
}) {
  if (value == null) return;

  switch (schema) {
    case SchemaPropertyString(:final shouldBeTranslated):
      if (shouldBeTranslated && value is String && value.isNotEmpty) {
        result[path] = value;
      }

    case SchemaPropertyArray(:final items):
      if (value is List) {
        for (var i = 0; i < value.length; i++) {
          _extractTranslatableStrings(
            schema: items,
            value: value[i],
            path: '$path[$i]',
            result: result,
          );
        }
      }

    case SchemaPropertyStructuredObjectWithDefinedProperties(:final properties):
      if (value is Map<String, dynamic>) {
        for (final entry in properties.entries) {
          final key = entry.key;
          final propertySchema = entry.value;
          if (value.containsKey(key)) {
            _extractTranslatableStrings(
              schema: propertySchema,
              value: value[key],
              path: '$path.$key',
              result: result,
            );
          }
        }
      }

    // Other types don't have translatable content
    case SchemaPropertyInteger():
    case SchemaPropertyDouble():
    case SchemaPropertyBoolean():
    case SchemaPropertyEnum():
    case SchemaPropertyObjectWithUndefinedProperties():
      break;
  }
}

/// Translates a map of strings in parallel batches.
///
/// Splits [textsToTranslate] into chunks of size [kTranslationBatchSize],
/// dispatches all chunks concurrently via [Future.wait], and merges the
/// results back into a single map.
///
/// Edge cases handled:
/// - Empty map: returns immediately with an empty map (no API calls).
/// - Single string or count <= [kTranslationBatchSize]: a single API call
///   is made (no overhead from chunking).
/// - Many strings (>100): chunked into ceil(n / batchSize) parallel requests.
Future<Map<String, String>> _translateInParallelBatches({
  required IOpenAiService openAiService,
  required Map<String, String> textsToTranslate,
  required String sourceLanguage,
  required String targetLanguage,
}) async {
  if (textsToTranslate.isEmpty) {
    return {};
  }

  final chunks = _chunkMap(textsToTranslate, kTranslationBatchSize);

  // Send all chunks in parallel. Each chunk becomes one API request.
  final futures = chunks.map(
    (chunk) => openAiService.translateTexts(
      textsToTranslate: chunk,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    ),
  );

  final results = await Future.wait(futures);

  // Merge all batch results into a single map
  final merged = <String, String>{};
  for (final batchResult in results) {
    merged.addAll(batchResult);
  }
  return merged;
}

/// Splits a map into a list of smaller maps, each containing at most
/// [chunkSize] entries. Preserves insertion order within each chunk.
List<Map<String, String>> _chunkMap(
  Map<String, String> source,
  int chunkSize,
) {
  if (source.length <= chunkSize) {
    return [source];
  }

  final chunks = <Map<String, String>>[];
  var currentChunk = <String, String>{};

  for (final entry in source.entries) {
    currentChunk[entry.key] = entry.value;
    if (currentChunk.length >= chunkSize) {
      chunks.add(currentChunk);
      currentChunk = <String, String>{};
    }
  }

  // Add the remaining partial chunk if non-empty
  if (currentChunk.isNotEmpty) {
    chunks.add(currentChunk);
  }

  return chunks;
}

/// Reconstructs JSON with translated values applied.
Object? _applyTranslations({
  required SchemaProperty schema,
  required Object? value,
  required String path,
  required Map<String, String> translations,
}) {
  if (value == null) return null;

  switch (schema) {
    case SchemaPropertyString(:final shouldBeTranslated):
      if (shouldBeTranslated && translations.containsKey(path)) {
        return translations[path];
      }
      return value;

    case SchemaPropertyArray(:final items):
      if (value is List) {
        return [
          for (var i = 0; i < value.length; i++)
            _applyTranslations(
              schema: items,
              value: value[i],
              path: '$path[$i]',
              translations: translations,
            ),
        ];
      }
      return value;

    case SchemaPropertyStructuredObjectWithDefinedProperties(:final properties):
      if (value is Map<String, dynamic>) {
        final result = <String, dynamic>{};
        // Preserve all keys from the original value
        for (final key in value.keys) {
          if (properties.containsKey(key)) {
            result[key] = _applyTranslations(
              schema: properties[key]!,
              value: value[key],
              path: '$path.$key',
              translations: translations,
            );
          } else {
            // Key not in schema, preserve as-is
            result[key] = value[key];
          }
        }
        return result;
      }
      return value;

    // Other types are passed through unchanged
    case SchemaPropertyInteger():
    case SchemaPropertyDouble():
    case SchemaPropertyBoolean():
    case SchemaPropertyEnum():
    case SchemaPropertyObjectWithUndefinedProperties():
      return value;
  }
}

/// Converts SupportedLanguage enum to human-readable language name for AI prompt.
String _languageToDisplayName(SupportedLanguage language) {
  return switch (language) {
    SupportedLanguage.english => 'English',
    SupportedLanguage.simplifiedMandarinChinese =>
      'Simplified Mandarin Chinese',
    SupportedLanguage.traditionalChinese => 'Traditional Chinese',
    SupportedLanguage.spanish => 'Spanish',
    SupportedLanguage.french => 'French',
    SupportedLanguage.brazilianPortuguese => 'Brazilian Portuguese',
    SupportedLanguage.portugalPortuguese => 'Portugal Portuguese',
    SupportedLanguage.russian => 'Russian',
    SupportedLanguage.ukrainian => 'Ukrainian',
    SupportedLanguage.polish => 'Polish',
    SupportedLanguage.indonesian => 'Indonesian',
    SupportedLanguage.malay => 'Malay',
    SupportedLanguage.german => 'German',
    SupportedLanguage.dutch => 'Dutch',
    SupportedLanguage.japanese => 'Japanese',
    SupportedLanguage.swahili => 'Swahili',
    SupportedLanguage.turkish => 'Turkish',
    SupportedLanguage.vietnamese => 'Vietnamese',
    SupportedLanguage.korean => 'Korean',
    SupportedLanguage.italian => 'Italian',
    SupportedLanguage.filipino => 'Filipino',
    SupportedLanguage.romanian => 'Romanian',
    SupportedLanguage.swedish => 'Swedish',
    SupportedLanguage.czech => 'Czech',
  };
}

/// Extension to provide validation for SchemaPropertyStructuredObjectWithDefinedProperties
extension SchemaPropertyStructuredObjectValidation
    on SchemaPropertyStructuredObjectWithDefinedProperties {
  /// Validates if a given JSON object follows this schema structure.
  /// If a field is required (not nullable) it must be present.
  /// If a field is nullable it can be absent or null, but if it is present it must follow the schema.
  /// Returns null if valid, error message if invalid.
  String? validateJsonFollowsSchemaStructure(Map<String, dynamic> model) {
    return _validateValueForSchema(this, model, _kRootPath);
  }

  static String? _validateValueForSchema(
    SchemaProperty schema,
    Object? value,
    String path,
  ) {
    if (value == null) {
      if (!schema.nullable) {
        return 'Expected non-null value at $path but got null (field is not nullable)';
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
          return 'Expected num (double) at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyBoolean():
        if (value is! bool) {
          return 'Expected bool at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyEnum(:final enumValues):
        if (value is! String) {
          return 'Expected String (enum) at $path but got ${value.runtimeType}';
        }
        if (!enumValues.contains(value)) {
          return 'Invalid enum value at $path: "$value" is not one of [${enumValues.join(', ')}]';
        }
        return null;
      case SchemaPropertyArray(:final items):
        if (value is! List) {
          return 'Expected List at $path but got ${value.runtimeType}';
        }
        for (var i = 0; i < value.length; i++) {
          final error = _validateValueForSchema(items, value[i], '$path[$i]');
          if (error != null) {
            return error;
          }
        }
        return null;
      case SchemaPropertyObjectWithUndefinedProperties():
        if (value is! Map<String, dynamic>) {
          return 'Expected Map<String, dynamic> at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyStructuredObjectWithDefinedProperties(
        :final properties,
      ):
        if (value is! Map<String, dynamic>) {
          return 'Expected Map<String, dynamic> at $path but got ${value.runtimeType}';
        }

        for (final entry in properties.entries) {
          final key = entry.key;
          final propertySchema = entry.value;
          final hasKey = value.containsKey(key);

          if (!hasKey) {
            if (!propertySchema.nullable) {
              return 'Missing required field "$key" at $path (field is not nullable)';
            }
            continue;
          }

          final propertyValue = value[key];
          final error = _validateValueForSchema(
            propertySchema,
            propertyValue,
            '$path.$key',
          );
          if (error != null) {
            return error;
          }
        }
        return null;
    }
  }
}

/// Extension to provide additional functionality for SchemaDefinition
extension SchemaDefinitionExtension on SchemaDefinition {
  /// Converts the SchemaDefinition to a JSON map
  Map<String, dynamic> toSchemaJson() =>
      properties.map((key, value) => MapEntry(key, value.toSchemaJson()));

  /// Returns a formatted JSON string representation
  String toSchemaString() => _kPrettyJsonEncoder.convert(toSchemaJson());

  /// Converts to a SchemaPropertyStructuredObjectWithDefinedProperties
  SchemaPropertyStructuredObjectWithDefinedProperties toSchemaProperty() =>
      SchemaPropertyStructuredObjectWithDefinedProperties(
        nullable: false,
        properties: properties,
      );
}

/// Static methods for SchemaDefinition that can't be in extension
class SchemaDefinitionParser {
  /// Creates a SchemaDefinition from a JSON map
  static SchemaDefinition fromJson(Map<String, dynamic> json) {
    final properties = json.map(
      (key, value) => MapEntry(
        key,
        SchemaPropertyParser.fromJson(value as Map<String, dynamic>),
      ),
    );
    return SchemaDefinition(properties: properties);
  }
}

/// Extension to convert SchemaProperty to OpenRouter JSON Schema format
extension SchemaPropertyToOpenRouterSchema on SchemaProperty {
  /// Converts a SchemaProperty to OpenRouter-compatible JSON Schema format.
  /// This format is used for structured outputs with the response_format parameter.
  Map<String, dynamic> toOpenRouterJsonSchema() {
    final schema = <String, dynamic>{};

    // Add description if present
    if (description != null) {
      schema['description'] = description;
    }

    switch (this) {
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
        schema['items'] = items.toOpenRouterJsonSchema();

      case SchemaPropertyObjectWithUndefinedProperties():
        schema['type'] = 'object';

      case SchemaPropertyStructuredObjectWithDefinedProperties(
        :final properties,
      ):
        schema['type'] = 'object';
        schema.addAll(_buildOpenRouterPropertiesSchema(properties));
    }

    return schema;
  }
}

/// Builds the properties, required, and additionalProperties entries
/// for a set of [SchemaProperty] fields in OpenRouter JSON Schema format.
Map<String, dynamic> _buildOpenRouterPropertiesSchema(
  Map<String, SchemaProperty> properties,
) {
  final schemaProperties = <String, dynamic>{};
  final requiredFields = <String>[];

  for (final entry in properties.entries) {
    schemaProperties[entry.key] = entry.value.toOpenRouterJsonSchema();
    if (!entry.value.nullable) {
      requiredFields.add(entry.key);
    }
  }

  return {
    'properties': schemaProperties,
    'required': requiredFields,
    'additionalProperties': false,
  };
}

/// Extension to convert `Map<String, SchemaProperty>` to OpenRouter JSON Schema
extension SchemaPropertiesMapToOpenRouter on Map<String, SchemaProperty> {
  /// Converts a map of SchemaProperty to OpenRouter JSON Schema format.
  /// This produces a complete JSON Schema object suitable for the response_format parameter.
  Map<String, dynamic> toOpenRouterJsonSchema() {
    return {
      'type': 'object',
      ..._buildOpenRouterPropertiesSchema(this),
    };
  }
}

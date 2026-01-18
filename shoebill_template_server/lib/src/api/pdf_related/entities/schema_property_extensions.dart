import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/ai_services.dart';

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
  String toSchemaString() =>
      JsonEncoder.withIndent('  ').convert(toSchemaJson());
}

/// Static methods for SchemaProperty that can't be in extension
class SchemaPropertyParser {
  /// Creates a SchemaProperty from a JSON map
  static SchemaProperty fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final nullable = json['nullable'] as bool;
    final description = json['description'] as String?;

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
        final enumValues = (json['possibleEnumValues'] as List<dynamic>)
            .cast<String>();
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
        throw ArgumentError('Unknown SchemaProperty type: $type');
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
  /// Throws [ShoebillException] if the JSON is invalid or translation fails.
  Future<String> translateBasedOnSchema({
    required String stringifiedJson,
    required SupportedLanguages sourceLanguage,
    required SupportedLanguages targetLanguage,
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
      path: 'root',
      result: translatableStrings,
    );

    if (translatableStrings.isEmpty) {
      // No strings to translate, return original
      return stringifiedJson;
    }

    // Import the openAiService from server.dart
    final openAiService = _getOpenAiService();

    // Translate all strings in batch
    final Map<String, String> translatedStrings;
    try {
      translatedStrings = await openAiService.translateTexts(
        textsToTranslate: translatableStrings,
        sourceLanguage: _languageToDisplayName(sourceLanguage),
        targetLanguage: _languageToDisplayName(targetLanguage),
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
      path: 'root',
      translations: translatedStrings,
    );

    return JsonEncoder.withIndent('  ').convert(targetJson);
  }
}

/// Helper to extract all translatable strings from JSON based on schema.
void _extractTranslatableStrings({
  required SchemaProperty schema,
  required dynamic value,
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

/// Reconstructs JSON with translated values applied.
dynamic _applyTranslations({
  required SchemaProperty schema,
  required dynamic value,
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

/// Converts SupportedLanguages enum to human-readable language name for AI prompt.
String _languageToDisplayName(SupportedLanguages language) {
  return switch (language) {
    SupportedLanguages.english => 'English',
    SupportedLanguages.mandarinChinese => 'Mandarin Chinese',
    SupportedLanguages.hindi => 'Hindi',
    SupportedLanguages.spanish => 'Spanish',
    SupportedLanguages.french => 'French',
    SupportedLanguages.modernStandardArabic => 'Modern Standard Arabic',
    SupportedLanguages.bengali => 'Bengali',
    SupportedLanguages.brazilianPortuguese => 'Brazilian Portuguese',
    SupportedLanguages.russian => 'Russian',
    SupportedLanguages.urdu => 'Urdu',
    SupportedLanguages.indonesian => 'Indonesian',
    SupportedLanguages.german => 'German',
    SupportedLanguages.dutch => 'Dutch',
    SupportedLanguages.japanese => 'Japanese',
    SupportedLanguages.swahili => 'Swahili',
    SupportedLanguages.marathi => 'Marathi',
    SupportedLanguages.telugu => 'Telugu',
    SupportedLanguages.turkish => 'Turkish',
    SupportedLanguages.tamil => 'Tamil',
    SupportedLanguages.vietnamese => 'Vietnamese',
    SupportedLanguages.korean => 'Korean',
    SupportedLanguages.italian => 'Italian',
    SupportedLanguages.thai => 'Thai',
    SupportedLanguages.filipino => 'Filipino',
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
    return _validateValueForSchema(this, model, 'root');
  }

  static String? _validateValueForSchema(
    SchemaProperty schema,
    dynamic value,
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
  String toSchemaString() =>
      JsonEncoder.withIndent('  ').convert(toSchemaJson());

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

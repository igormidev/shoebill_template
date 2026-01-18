import 'dart:convert';

import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

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

  Future<String> translateBasedOnSchema({
    required String stringifiedJson,
    required SupportedLanguages sourceLanguage,
    required SupportedLanguages targetLanguage,
  }) async {
    final sourceJson = tryDecode(stringifiedJson);
    final targetJson = <String, dynamic>{};

    // TODO: Implement translation logic - translate with AI and only for strings with shouldBeTranslated = true

    return JsonEncoder.withIndent('  ').convert(targetJson);
  }
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

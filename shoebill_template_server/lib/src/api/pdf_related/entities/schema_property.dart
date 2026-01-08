import 'dart:convert';

class SchemaDefinition {
  final Map<String, SchemaProperty> properties;
  SchemaDefinition({required this.properties});

  Map<String, dynamic> toJson() =>
      properties.map((key, value) => MapEntry(key, value.toJson()));

  @override
  String toString() => JsonEncoder.withIndent('  ').convert(toJson());

  SchemaPropertyStructuredObjectWithDefinedProperties toSchemaProperty() =>
      SchemaPropertyStructuredObjectWithDefinedProperties(
        nullable: false,
        properties: properties,
      );
}

sealed class SchemaProperty {
  final String type;
  final bool nullable;
  final String? description;
  SchemaProperty({required this.type, this.nullable = false, this.description});

  factory SchemaProperty.text({
    required bool nullable,
    String? description,
    bool shouldBeTranslated,
  }) = SchemaPropertyString;
  factory SchemaProperty.integer({
    required bool nullable,
    String? description,
  }) = SchemaPropertyInteger;
  factory SchemaProperty.double({required bool nullable, String? description}) =
      SchemaPropertyDouble;
  factory SchemaProperty.boolean({
    required bool nullable,
    String? description,
  }) = SchemaPropertyBoolean;
  factory SchemaProperty.enumeration({
    required List<String> enumValues,
    required bool nullable,
    String? description,
  }) = SchemaPropertyEnum;
  factory SchemaProperty.array({
    required SchemaProperty items,
    required bool nullable,
    String? description,
  }) = SchemaPropertyArray;
  factory SchemaProperty.structuredObject({
    required Map<String, SchemaProperty> properties,
    required bool nullable,
    String? description,
  }) = SchemaPropertyStructuredObjectWithDefinedProperties;
  factory SchemaProperty.objectWithUndefinedProperties({
    required bool nullable,
    String? description,
  }) = SchemaPropertyObjectWithUndefinedProperties;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'type': type,
      'nullable': nullable,
      if (description != null) 'description': description,
    };

    switch (this) {
      case SchemaPropertyString():
        if ((this as SchemaPropertyString).shouldBeTranslated) {
          json['shouldBeTranslated'] = true;
        }
      case SchemaPropertyEnum():
        json['possibleEnumValues'] = (this as SchemaPropertyEnum).enumValues;
      case SchemaPropertyArray():
        json['items'] = (this as SchemaPropertyArray).items.toJson();
      case SchemaPropertyStructuredObjectWithDefinedProperties():
        json['properties'] =
            (this as SchemaPropertyStructuredObjectWithDefinedProperties)
                .properties
                .map((key, value) => MapEntry(key, value.toJson()));
      default:
        // No additional fields for other types
        break;
    }
    return json;
  }

  @override
  String toString() => JsonEncoder.withIndent('  ').convert(toJson());
}

class SchemaPropertyString extends SchemaProperty {
  final bool shouldBeTranslated;
  SchemaPropertyString({
    required super.nullable,
    super.description,
    this.shouldBeTranslated = false,
  }) : super(type: 'string');
}

class SchemaPropertyInteger extends SchemaProperty {
  SchemaPropertyInteger({required super.nullable, super.description})
    : super(type: 'integer');
}

class SchemaPropertyDouble extends SchemaProperty {
  SchemaPropertyDouble({required super.nullable, super.description})
    : super(type: 'double');
}

class SchemaPropertyBoolean extends SchemaProperty {
  SchemaPropertyBoolean({required super.nullable, super.description})
    : super(type: 'boolean');
}

class SchemaPropertyEnum extends SchemaProperty {
  final List<String> enumValues;
  SchemaPropertyEnum({
    required this.enumValues,
    required super.nullable,
    super.description,
  }) : super(type: 'enum');
}

class SchemaPropertyArray extends SchemaProperty {
  final SchemaProperty items;
  SchemaPropertyArray({
    required this.items,
    required super.nullable,
    super.description,
  }) : super(type: 'array');
}

class SchemaPropertyObjectWithUndefinedProperties extends SchemaProperty {
  SchemaPropertyObjectWithUndefinedProperties({
    required super.nullable,
    super.description,
  }) : super(type: 'dynamic_object_with_undefined_properties');
}

class SchemaPropertyStructuredObjectWithDefinedProperties
    extends SchemaProperty {
  final Map<String, SchemaProperty> properties;
  SchemaPropertyStructuredObjectWithDefinedProperties({
    required this.properties,
    required super.nullable,
    super.description,
  }) : super(type: 'structured_object_with_defined_properties');

  // Will see if a given JSON object follows this schema structure
  // If a field is required (not nullable) it must be present
  // If a field is nullable it can be absent or null, but if it is present it must follow the schema
  // Returns null if valid, error message if invalid
  String? validateIdJsonFollowsSchemaStructure(Map<String, dynamic> model) {
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

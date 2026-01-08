import 'package:test/test.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property.dart';

void main() {
  group('SchemaPropertyString', () {
    group('toJson', () {
      test('serializes non-nullable string without description', () {
        final prop = SchemaPropertyString(nullable: false);
        final json = prop.toJson();

        expect(json['type'], 'string');
        expect(json['nullable'], false);
        expect(json.containsKey('description'), false);
        expect(json.containsKey('shouldBeTranslated'), false);
      });

      test('serializes nullable string with description', () {
        final prop = SchemaPropertyString(
          nullable: true,
          description: 'A test string',
        );
        final json = prop.toJson();

        expect(json['type'], 'string');
        expect(json['nullable'], true);
        expect(json['description'], 'A test string');
      });

      test('serializes shouldBeTranslated when true', () {
        final prop = SchemaPropertyString(
          nullable: false,
          shouldBeTranslated: true,
        );
        final json = prop.toJson();

        expect(json['shouldBeTranslated'], true);
      });

      test('does not include shouldBeTranslated when false', () {
        final prop = SchemaPropertyString(
          nullable: false,
          shouldBeTranslated: false,
        );
        final json = prop.toJson();

        expect(json.containsKey('shouldBeTranslated'), false);
      });

      test('serializes all fields together', () {
        final prop = SchemaPropertyString(
          nullable: true,
          description: 'Translatable field',
          shouldBeTranslated: true,
        );
        final json = prop.toJson();

        expect(json['type'], 'string');
        expect(json['nullable'], true);
        expect(json['description'], 'Translatable field');
        expect(json['shouldBeTranslated'], true);
      });
    });

    group('fromJson', () {
      test('deserializes basic non-nullable string', () {
        final json = {'type': 'string', 'nullable': false};
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyString>());
        expect(prop.type, 'string');
        expect(prop.nullable, false);
        expect(prop.description, null);
        expect((prop as SchemaPropertyString).shouldBeTranslated, false);
      });

      test('deserializes nullable string with description', () {
        final json = {
          'type': 'string',
          'nullable': true,
          'description': 'User name',
        };
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyString>());
        expect(prop.nullable, true);
        expect(prop.description, 'User name');
      });

      test('deserializes shouldBeTranslated true', () {
        final json = {
          'type': 'string',
          'nullable': false,
          'shouldBeTranslated': true,
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyString;

        expect(prop.shouldBeTranslated, true);
      });

      test('deserializes shouldBeTranslated false when missing', () {
        final json = {'type': 'string', 'nullable': false};
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyString;

        expect(prop.shouldBeTranslated, false);
      });

      test('deserializes all fields together', () {
        final json = {
          'type': 'string',
          'nullable': true,
          'description': 'Full description',
          'shouldBeTranslated': true,
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyString;

        expect(prop.nullable, true);
        expect(prop.description, 'Full description');
        expect(prop.shouldBeTranslated, true);
      });
    });

    group('roundtrip', () {
      test('non-nullable without description', () {
        final original = SchemaPropertyString(nullable: false);
        final restored = SchemaProperty.fromJson(original.toJson());

        expect(restored, isA<SchemaPropertyString>());
        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
        expect(
          (restored as SchemaPropertyString).shouldBeTranslated,
          original.shouldBeTranslated,
        );
      });

      test('nullable with description and shouldBeTranslated', () {
        final original = SchemaPropertyString(
          nullable: true,
          description: 'Test description',
          shouldBeTranslated: true,
        );
        final restored =
            SchemaProperty.fromJson(original.toJson()) as SchemaPropertyString;

        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
        expect(restored.shouldBeTranslated, original.shouldBeTranslated);
      });
    });
  });

  group('SchemaPropertyInteger', () {
    group('toJson', () {
      test('serializes non-nullable integer', () {
        final prop = SchemaPropertyInteger(nullable: false);
        final json = prop.toJson();

        expect(json['type'], 'integer');
        expect(json['nullable'], false);
        expect(json.containsKey('description'), false);
      });

      test('serializes nullable integer with description', () {
        final prop = SchemaPropertyInteger(
          nullable: true,
          description: 'Count value',
        );
        final json = prop.toJson();

        expect(json['type'], 'integer');
        expect(json['nullable'], true);
        expect(json['description'], 'Count value');
      });
    });

    group('fromJson', () {
      test('deserializes basic integer', () {
        final json = {'type': 'integer', 'nullable': false};
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyInteger>());
        expect(prop.type, 'integer');
        expect(prop.nullable, false);
      });

      test('deserializes nullable integer with description', () {
        final json = {
          'type': 'integer',
          'nullable': true,
          'description': 'Age field',
        };
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyInteger>());
        expect(prop.nullable, true);
        expect(prop.description, 'Age field');
      });
    });

    group('roundtrip', () {
      test('preserves all properties', () {
        final original = SchemaPropertyInteger(
          nullable: true,
          description: 'User age',
        );
        final restored = SchemaProperty.fromJson(original.toJson());

        expect(restored, isA<SchemaPropertyInteger>());
        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
      });
    });
  });

  group('SchemaPropertyDouble', () {
    group('toJson', () {
      test('serializes non-nullable double', () {
        final prop = SchemaPropertyDouble(nullable: false);
        final json = prop.toJson();

        expect(json['type'], 'double');
        expect(json['nullable'], false);
      });

      test('serializes nullable double with description', () {
        final prop = SchemaPropertyDouble(
          nullable: true,
          description: 'Price value',
        );
        final json = prop.toJson();

        expect(json['type'], 'double');
        expect(json['nullable'], true);
        expect(json['description'], 'Price value');
      });
    });

    group('fromJson', () {
      test('deserializes basic double', () {
        final json = {'type': 'double', 'nullable': false};
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyDouble>());
        expect(prop.type, 'double');
        expect(prop.nullable, false);
      });

      test('deserializes nullable double with description', () {
        final json = {
          'type': 'double',
          'nullable': true,
          'description': 'Temperature',
        };
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyDouble>());
        expect(prop.nullable, true);
        expect(prop.description, 'Temperature');
      });
    });

    group('roundtrip', () {
      test('preserves all properties', () {
        final original = SchemaPropertyDouble(
          nullable: false,
          description: 'Rating score',
        );
        final restored = SchemaProperty.fromJson(original.toJson());

        expect(restored, isA<SchemaPropertyDouble>());
        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
      });
    });
  });

  group('SchemaPropertyBoolean', () {
    group('toJson', () {
      test('serializes non-nullable boolean', () {
        final prop = SchemaPropertyBoolean(nullable: false);
        final json = prop.toJson();

        expect(json['type'], 'boolean');
        expect(json['nullable'], false);
      });

      test('serializes nullable boolean with description', () {
        final prop = SchemaPropertyBoolean(
          nullable: true,
          description: 'Is active flag',
        );
        final json = prop.toJson();

        expect(json['type'], 'boolean');
        expect(json['nullable'], true);
        expect(json['description'], 'Is active flag');
      });
    });

    group('fromJson', () {
      test('deserializes basic boolean', () {
        final json = {'type': 'boolean', 'nullable': false};
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyBoolean>());
        expect(prop.type, 'boolean');
        expect(prop.nullable, false);
      });

      test('deserializes nullable boolean with description', () {
        final json = {
          'type': 'boolean',
          'nullable': true,
          'description': 'Enabled status',
        };
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyBoolean>());
        expect(prop.nullable, true);
        expect(prop.description, 'Enabled status');
      });
    });

    group('roundtrip', () {
      test('preserves all properties', () {
        final original = SchemaPropertyBoolean(
          nullable: true,
          description: 'Has premium',
        );
        final restored = SchemaProperty.fromJson(original.toJson());

        expect(restored, isA<SchemaPropertyBoolean>());
        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
      });
    });
  });

  group('SchemaPropertyEnum', () {
    group('toJson', () {
      test('serializes non-nullable enum', () {
        final prop = SchemaPropertyEnum(
          enumValues: ['RED', 'GREEN', 'BLUE'],
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['type'], 'enum');
        expect(json['nullable'], false);
        expect(json['possibleEnumValues'], ['RED', 'GREEN', 'BLUE']);
      });

      test('serializes nullable enum with description', () {
        final prop = SchemaPropertyEnum(
          enumValues: ['PENDING', 'APPROVED', 'REJECTED'],
          nullable: true,
          description: 'Status of the request',
        );
        final json = prop.toJson();

        expect(json['type'], 'enum');
        expect(json['nullable'], true);
        expect(json['description'], 'Status of the request');
        expect(json['possibleEnumValues'], ['PENDING', 'APPROVED', 'REJECTED']);
      });

      test('serializes empty enum values list', () {
        final prop = SchemaPropertyEnum(enumValues: [], nullable: false);
        final json = prop.toJson();

        expect(json['possibleEnumValues'], []);
      });

      test('serializes single enum value', () {
        final prop = SchemaPropertyEnum(enumValues: ['ONLY'], nullable: false);
        final json = prop.toJson();

        expect(json['possibleEnumValues'], ['ONLY']);
      });
    });

    group('fromJson', () {
      test('deserializes basic enum', () {
        final json = {
          'type': 'enum',
          'nullable': false,
          'possibleEnumValues': ['A', 'B', 'C'],
        };
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyEnum>());
        expect(prop.type, 'enum');
        expect(prop.nullable, false);
        expect((prop as SchemaPropertyEnum).enumValues, ['A', 'B', 'C']);
      });

      test('deserializes nullable enum with description', () {
        final json = {
          'type': 'enum',
          'nullable': true,
          'description': 'Priority level',
          'possibleEnumValues': ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'],
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyEnum;

        expect(prop.nullable, true);
        expect(prop.description, 'Priority level');
        expect(prop.enumValues, ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']);
      });

      test('deserializes empty enum values', () {
        final json = {
          'type': 'enum',
          'nullable': false,
          'possibleEnumValues': <String>[],
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyEnum;

        expect(prop.enumValues, isEmpty);
      });
    });

    group('roundtrip', () {
      test('preserves all properties', () {
        final original = SchemaPropertyEnum(
          enumValues: ['DRAFT', 'PUBLISHED', 'ARCHIVED'],
          nullable: true,
          description: 'Document status',
        );
        final restored =
            SchemaProperty.fromJson(original.toJson()) as SchemaPropertyEnum;

        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
        expect(restored.enumValues, original.enumValues);
      });

      test('preserves enum values order', () {
        final original = SchemaPropertyEnum(
          enumValues: ['FIRST', 'SECOND', 'THIRD', 'FOURTH'],
          nullable: false,
        );
        final restored =
            SchemaProperty.fromJson(original.toJson()) as SchemaPropertyEnum;

        expect(restored.enumValues, orderedEquals(original.enumValues));
      });
    });
  });

  group('SchemaPropertyArray', () {
    group('toJson', () {
      test('serializes array of strings', () {
        final prop = SchemaPropertyArray(
          items: SchemaPropertyString(nullable: false),
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['type'], 'array');
        expect(json['nullable'], false);
        expect(json['items'], isA<Map>());
        expect(json['items']['type'], 'string');
      });

      test('serializes nullable array with description', () {
        final prop = SchemaPropertyArray(
          items: SchemaPropertyInteger(nullable: true),
          nullable: true,
          description: 'List of IDs',
        );
        final json = prop.toJson();

        expect(json['type'], 'array');
        expect(json['nullable'], true);
        expect(json['description'], 'List of IDs');
        expect(json['items']['type'], 'integer');
        expect(json['items']['nullable'], true);
      });

      test('serializes array of enums', () {
        final prop = SchemaPropertyArray(
          items: SchemaPropertyEnum(
            enumValues: ['ADMIN', 'USER', 'GUEST'],
            nullable: false,
          ),
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['items']['type'], 'enum');
        expect(json['items']['possibleEnumValues'], ['ADMIN', 'USER', 'GUEST']);
      });

      test('serializes nested array (array of arrays)', () {
        final prop = SchemaPropertyArray(
          items: SchemaPropertyArray(
            items: SchemaPropertyInteger(nullable: false),
            nullable: false,
          ),
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['type'], 'array');
        expect(json['items']['type'], 'array');
        expect(json['items']['items']['type'], 'integer');
      });

      test('serializes array of objects', () {
        final prop = SchemaPropertyArray(
          items: SchemaPropertyStructuredObjectWithDefinedProperties(
            properties: {
              'id': SchemaPropertyInteger(nullable: false),
              'name': SchemaPropertyString(nullable: false),
            },
            nullable: false,
          ),
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['items']['type'], 'structured_object_with_defined_properties');
        expect(json['items']['properties']['id']['type'], 'integer');
        expect(json['items']['properties']['name']['type'], 'string');
      });
    });

    group('fromJson', () {
      test('deserializes array of strings', () {
        final json = {
          'type': 'array',
          'nullable': false,
          'items': {'type': 'string', 'nullable': false},
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyArray;

        expect(prop.type, 'array');
        expect(prop.nullable, false);
        expect(prop.items, isA<SchemaPropertyString>());
      });

      test('deserializes nullable array with description', () {
        final json = {
          'type': 'array',
          'nullable': true,
          'description': 'Tags list',
          'items': {'type': 'string', 'nullable': true},
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyArray;

        expect(prop.nullable, true);
        expect(prop.description, 'Tags list');
        expect(prop.items.nullable, true);
      });

      test('deserializes array of booleans', () {
        final json = {
          'type': 'array',
          'nullable': false,
          'items': {'type': 'boolean', 'nullable': false},
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyArray;

        expect(prop.items, isA<SchemaPropertyBoolean>());
      });

      test('deserializes array of doubles', () {
        final json = {
          'type': 'array',
          'nullable': false,
          'items': {'type': 'double', 'nullable': false},
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyArray;

        expect(prop.items, isA<SchemaPropertyDouble>());
      });

      test('deserializes nested array', () {
        final json = {
          'type': 'array',
          'nullable': false,
          'items': {
            'type': 'array',
            'nullable': false,
            'items': {'type': 'string', 'nullable': false},
          },
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyArray;
        final innerArray = prop.items as SchemaPropertyArray;

        expect(innerArray.items, isA<SchemaPropertyString>());
      });

      test('deserializes deeply nested array (3 levels)', () {
        final json = {
          'type': 'array',
          'nullable': false,
          'items': {
            'type': 'array',
            'nullable': false,
            'items': {
              'type': 'array',
              'nullable': false,
              'items': {'type': 'integer', 'nullable': false},
            },
          },
        };
        final prop = SchemaProperty.fromJson(json) as SchemaPropertyArray;
        final level2 = prop.items as SchemaPropertyArray;
        final level3 = level2.items as SchemaPropertyArray;

        expect(level3.items, isA<SchemaPropertyInteger>());
      });
    });

    group('roundtrip', () {
      test('preserves array of strings', () {
        final original = SchemaPropertyArray(
          items: SchemaPropertyString(nullable: true, description: 'Item name'),
          nullable: false,
          description: 'Names list',
        );
        final restored =
            SchemaProperty.fromJson(original.toJson()) as SchemaPropertyArray;

        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
        expect(restored.items.nullable, original.items.nullable);
        expect(restored.items.description, original.items.description);
      });

      test('preserves nested array structure', () {
        final original = SchemaPropertyArray(
          items: SchemaPropertyArray(
            items: SchemaPropertyEnum(
              enumValues: ['X', 'Y', 'Z'],
              nullable: false,
            ),
            nullable: true,
          ),
          nullable: false,
        );
        final restored =
            SchemaProperty.fromJson(original.toJson()) as SchemaPropertyArray;
        final innerArray = restored.items as SchemaPropertyArray;
        final enumProp = innerArray.items as SchemaPropertyEnum;

        expect(innerArray.nullable, true);
        expect(enumProp.enumValues, ['X', 'Y', 'Z']);
      });
    });
  });

  group('SchemaPropertyObjectWithUndefinedProperties', () {
    group('toJson', () {
      test('serializes non-nullable object', () {
        final prop = SchemaPropertyObjectWithUndefinedProperties(nullable: false);
        final json = prop.toJson();

        expect(json['type'], 'dynamic_object_with_undefined_properties');
        expect(json['nullable'], false);
      });

      test('serializes nullable object with description', () {
        final prop = SchemaPropertyObjectWithUndefinedProperties(
          nullable: true,
          description: 'Arbitrary metadata',
        );
        final json = prop.toJson();

        expect(json['type'], 'dynamic_object_with_undefined_properties');
        expect(json['nullable'], true);
        expect(json['description'], 'Arbitrary metadata');
      });
    });

    group('fromJson', () {
      test('deserializes basic object', () {
        final json = {
          'type': 'dynamic_object_with_undefined_properties',
          'nullable': false,
        };
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyObjectWithUndefinedProperties>());
        expect(prop.nullable, false);
      });

      test('deserializes nullable object with description', () {
        final json = {
          'type': 'dynamic_object_with_undefined_properties',
          'nullable': true,
          'description': 'Extra data',
        };
        final prop = SchemaProperty.fromJson(json);

        expect(prop, isA<SchemaPropertyObjectWithUndefinedProperties>());
        expect(prop.nullable, true);
        expect(prop.description, 'Extra data');
      });
    });

    group('roundtrip', () {
      test('preserves all properties', () {
        final original = SchemaPropertyObjectWithUndefinedProperties(
          nullable: true,
          description: 'Dynamic config',
        );
        final restored = SchemaProperty.fromJson(original.toJson());

        expect(restored, isA<SchemaPropertyObjectWithUndefinedProperties>());
        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
      });
    });
  });

  group('SchemaPropertyStructuredObjectWithDefinedProperties', () {
    group('toJson', () {
      test('serializes object with single property', () {
        final prop = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'name': SchemaPropertyString(nullable: false),
          },
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['type'], 'structured_object_with_defined_properties');
        expect(json['nullable'], false);
        expect(json['properties'], isA<Map>());
        expect(json['properties']['name']['type'], 'string');
      });

      test('serializes object with multiple properties', () {
        final prop = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'id': SchemaPropertyInteger(nullable: false),
            'name': SchemaPropertyString(nullable: false),
            'email': SchemaPropertyString(nullable: true),
            'isActive': SchemaPropertyBoolean(nullable: false),
          },
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['properties'].keys, containsAll(['id', 'name', 'email', 'isActive']));
        expect(json['properties']['id']['type'], 'integer');
        expect(json['properties']['name']['type'], 'string');
        expect(json['properties']['email']['nullable'], true);
        expect(json['properties']['isActive']['type'], 'boolean');
      });

      test('serializes nested object', () {
        final prop = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'user': SchemaPropertyStructuredObjectWithDefinedProperties(
              properties: {
                'profile': SchemaPropertyStructuredObjectWithDefinedProperties(
                  properties: {
                    'bio': SchemaPropertyString(nullable: true),
                  },
                  nullable: false,
                ),
              },
              nullable: false,
            ),
          },
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['properties']['user']['properties']['profile']['properties']['bio']['type'], 'string');
      });

      test('serializes object with array property', () {
        final prop = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'tags': SchemaPropertyArray(
              items: SchemaPropertyString(nullable: false),
              nullable: false,
            ),
          },
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['properties']['tags']['type'], 'array');
        expect(json['properties']['tags']['items']['type'], 'string');
      });

      test('serializes object with enum property', () {
        final prop = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'status': SchemaPropertyEnum(
              enumValues: ['ACTIVE', 'INACTIVE'],
              nullable: false,
            ),
          },
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['properties']['status']['type'], 'enum');
        expect(json['properties']['status']['possibleEnumValues'], ['ACTIVE', 'INACTIVE']);
      });

      test('serializes empty properties object', () {
        final prop = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {},
          nullable: false,
        );
        final json = prop.toJson();

        expect(json['properties'], isEmpty);
      });
    });

    group('fromJson', () {
      test('deserializes object with single property', () {
        final json = {
          'type': 'structured_object_with_defined_properties',
          'nullable': false,
          'properties': {
            'title': {'type': 'string', 'nullable': false},
          },
        };
        final prop = SchemaProperty.fromJson(json)
            as SchemaPropertyStructuredObjectWithDefinedProperties;

        expect(prop.properties.keys, contains('title'));
        expect(prop.properties['title'], isA<SchemaPropertyString>());
      });

      test('deserializes object with multiple properties of different types', () {
        final json = {
          'type': 'structured_object_with_defined_properties',
          'nullable': true,
          'description': 'User object',
          'properties': {
            'id': {'type': 'integer', 'nullable': false},
            'name': {'type': 'string', 'nullable': false},
            'score': {'type': 'double', 'nullable': true},
            'verified': {'type': 'boolean', 'nullable': false},
            'role': {
              'type': 'enum',
              'nullable': false,
              'possibleEnumValues': ['ADMIN', 'USER'],
            },
          },
        };
        final prop = SchemaProperty.fromJson(json)
            as SchemaPropertyStructuredObjectWithDefinedProperties;

        expect(prop.nullable, true);
        expect(prop.description, 'User object');
        expect(prop.properties['id'], isA<SchemaPropertyInteger>());
        expect(prop.properties['name'], isA<SchemaPropertyString>());
        expect(prop.properties['score'], isA<SchemaPropertyDouble>());
        expect(prop.properties['verified'], isA<SchemaPropertyBoolean>());
        expect(prop.properties['role'], isA<SchemaPropertyEnum>());
      });

      test('deserializes nested object structure', () {
        final json = {
          'type': 'structured_object_with_defined_properties',
          'nullable': false,
          'properties': {
            'address': {
              'type': 'structured_object_with_defined_properties',
              'nullable': false,
              'properties': {
                'street': {'type': 'string', 'nullable': false},
                'city': {'type': 'string', 'nullable': false},
                'zip': {'type': 'string', 'nullable': true},
              },
            },
          },
        };
        final prop = SchemaProperty.fromJson(json)
            as SchemaPropertyStructuredObjectWithDefinedProperties;
        final address = prop.properties['address']
            as SchemaPropertyStructuredObjectWithDefinedProperties;

        expect(address.properties['street'], isA<SchemaPropertyString>());
        expect(address.properties['city'], isA<SchemaPropertyString>());
        expect(address.properties['zip']!.nullable, true);
      });

      test('deserializes object with array of objects', () {
        final json = {
          'type': 'structured_object_with_defined_properties',
          'nullable': false,
          'properties': {
            'items': {
              'type': 'array',
              'nullable': false,
              'items': {
                'type': 'structured_object_with_defined_properties',
                'nullable': false,
                'properties': {
                  'name': {'type': 'string', 'nullable': false},
                  'quantity': {'type': 'integer', 'nullable': false},
                },
              },
            },
          },
        };
        final prop = SchemaProperty.fromJson(json)
            as SchemaPropertyStructuredObjectWithDefinedProperties;
        final items = prop.properties['items'] as SchemaPropertyArray;
        final itemSchema =
            items.items as SchemaPropertyStructuredObjectWithDefinedProperties;

        expect(itemSchema.properties['name'], isA<SchemaPropertyString>());
        expect(itemSchema.properties['quantity'], isA<SchemaPropertyInteger>());
      });

      test('deserializes object with empty properties', () {
        final json = {
          'type': 'structured_object_with_defined_properties',
          'nullable': false,
          'properties': <String, dynamic>{},
        };
        final prop = SchemaProperty.fromJson(json)
            as SchemaPropertyStructuredObjectWithDefinedProperties;

        expect(prop.properties, isEmpty);
      });
    });

    group('roundtrip', () {
      test('preserves simple object', () {
        final original = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'field1': SchemaPropertyString(nullable: false),
            'field2': SchemaPropertyInteger(nullable: true, description: 'A number'),
          },
          nullable: true,
          description: 'Test object',
        );
        final restored = SchemaProperty.fromJson(original.toJson())
            as SchemaPropertyStructuredObjectWithDefinedProperties;

        expect(restored.nullable, original.nullable);
        expect(restored.description, original.description);
        expect(restored.properties.keys, original.properties.keys);
        expect(restored.properties['field1']!.nullable, false);
        expect(restored.properties['field2']!.nullable, true);
        expect(restored.properties['field2']!.description, 'A number');
      });

      test('preserves complex nested structure', () {
        final original = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'metadata': SchemaPropertyObjectWithUndefinedProperties(nullable: true),
            'items': SchemaPropertyArray(
              items: SchemaPropertyStructuredObjectWithDefinedProperties(
                properties: {
                  'id': SchemaPropertyInteger(nullable: false),
                  'type': SchemaPropertyEnum(
                    enumValues: ['A', 'B', 'C'],
                    nullable: false,
                  ),
                },
                nullable: false,
              ),
              nullable: false,
            ),
          },
          nullable: false,
        );
        final json = original.toJson();
        final restored = SchemaProperty.fromJson(json)
            as SchemaPropertyStructuredObjectWithDefinedProperties;

        expect(restored.properties['metadata'],
            isA<SchemaPropertyObjectWithUndefinedProperties>());

        final items = restored.properties['items'] as SchemaPropertyArray;
        final itemSchema =
            items.items as SchemaPropertyStructuredObjectWithDefinedProperties;
        final typeEnum = itemSchema.properties['type'] as SchemaPropertyEnum;

        expect(typeEnum.enumValues, ['A', 'B', 'C']);
      });
    });
  });

  group('SchemaDefinition', () {
    group('toJson', () {
      test('serializes empty definition', () {
        final def = SchemaDefinition(properties: {});
        final json = def.toJson();

        expect(json, isEmpty);
      });

      test('serializes single property', () {
        final def = SchemaDefinition(properties: {
          'name': SchemaPropertyString(nullable: false),
        });
        final json = def.toJson();

        expect(json['name']['type'], 'string');
      });

      test('serializes multiple properties', () {
        final def = SchemaDefinition(properties: {
          'id': SchemaPropertyInteger(nullable: false),
          'name': SchemaPropertyString(nullable: false),
          'active': SchemaPropertyBoolean(nullable: true),
        });
        final json = def.toJson();

        expect(json.keys, containsAll(['id', 'name', 'active']));
      });
    });

    group('fromJson', () {
      test('deserializes empty definition', () {
        final json = <String, dynamic>{};
        final def = SchemaDefinition.fromJson(json);

        expect(def.properties, isEmpty);
      });

      test('deserializes single property', () {
        final json = {
          'title': {'type': 'string', 'nullable': false},
        };
        final def = SchemaDefinition.fromJson(json);

        expect(def.properties['title'], isA<SchemaPropertyString>());
      });

      test('deserializes complex definition', () {
        final json = {
          'id': {'type': 'integer', 'nullable': false},
          'name': {
            'type': 'string',
            'nullable': false,
            'shouldBeTranslated': true,
          },
          'tags': {
            'type': 'array',
            'nullable': true,
            'items': {'type': 'string', 'nullable': false},
          },
          'config': {
            'type': 'dynamic_object_with_undefined_properties',
            'nullable': true,
          },
        };
        final def = SchemaDefinition.fromJson(json);

        expect(def.properties['id'], isA<SchemaPropertyInteger>());
        expect((def.properties['name'] as SchemaPropertyString).shouldBeTranslated, true);
        expect(def.properties['tags'], isA<SchemaPropertyArray>());
        expect(def.properties['config'], isA<SchemaPropertyObjectWithUndefinedProperties>());
      });
    });

    group('roundtrip', () {
      test('preserves all properties', () {
        final original = SchemaDefinition(properties: {
          'userId': SchemaPropertyInteger(nullable: false, description: 'Unique ID'),
          'username': SchemaPropertyString(nullable: false),
          'email': SchemaPropertyString(nullable: true, shouldBeTranslated: false),
          'roles': SchemaPropertyArray(
            items: SchemaPropertyEnum(
              enumValues: ['ADMIN', 'USER', 'MODERATOR'],
              nullable: false,
            ),
            nullable: false,
          ),
          'profile': SchemaPropertyStructuredObjectWithDefinedProperties(
            properties: {
              'bio': SchemaPropertyString(nullable: true, shouldBeTranslated: true),
              'age': SchemaPropertyInteger(nullable: true),
            },
            nullable: true,
          ),
        });
        final restored = SchemaDefinition.fromJson(original.toJson());

        expect(restored.properties.keys, original.properties.keys);
        expect(restored.properties['userId']!.description, 'Unique ID');
        expect(
          (restored.properties['profile']
                  as SchemaPropertyStructuredObjectWithDefinedProperties)
              .properties['bio']!
              .nullable,
          true,
        );
      });
    });

    group('toSchemaProperty', () {
      test('converts definition to structured object property', () {
        final def = SchemaDefinition(properties: {
          'field': SchemaPropertyString(nullable: false),
        });
        final prop = def.toSchemaProperty();

        expect(prop, isA<SchemaPropertyStructuredObjectWithDefinedProperties>());
        expect(prop.nullable, false);
        expect(prop.properties['field'], isA<SchemaPropertyString>());
      });
    });
  });

  group('SchemaProperty.fromJson error handling', () {
    test('throws on unknown type', () {
      final json = {'type': 'unknown_type', 'nullable': false};

      expect(
        () => SchemaProperty.fromJson(json),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Unknown SchemaProperty type: unknown_type'),
        )),
      );
    });

    test('throws on missing type field', () {
      final json = {'nullable': false};

      expect(() => SchemaProperty.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws on missing nullable field', () {
      final json = {'type': 'string'};

      expect(() => SchemaProperty.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws on null type', () {
      final json = {'type': null, 'nullable': false};

      expect(() => SchemaProperty.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws on invalid nullable type', () {
      final json = {'type': 'string', 'nullable': 'yes'};

      expect(() => SchemaProperty.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws on missing enum values for enum type', () {
      final json = {'type': 'enum', 'nullable': false};

      expect(() => SchemaProperty.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws on missing items for array type', () {
      final json = {'type': 'array', 'nullable': false};

      expect(() => SchemaProperty.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws on missing properties for structured object type', () {
      final json = {
        'type': 'structured_object_with_defined_properties',
        'nullable': false,
      };

      expect(() => SchemaProperty.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('validateIdJsonFollowsSchemaStructure', () {
    group('string validation', () {
      test('accepts valid string', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'name': SchemaPropertyString(nullable: false)},
          nullable: false,
        );

        expect(schema.validateIdJsonFollowsSchemaStructure({'name': 'John'}), isNull);
      });

      test('rejects non-string value', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'name': SchemaPropertyString(nullable: false)},
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'name': 123}),
          contains('Expected String'),
        );
      });

      test('accepts null for nullable string', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'name': SchemaPropertyString(nullable: true)},
          nullable: false,
        );

        expect(schema.validateIdJsonFollowsSchemaStructure({'name': null}), isNull);
      });

      test('rejects null for non-nullable string', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'name': SchemaPropertyString(nullable: false)},
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'name': null}),
          contains('not nullable'),
        );
      });
    });

    group('integer validation', () {
      test('accepts valid integer', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'count': SchemaPropertyInteger(nullable: false)},
          nullable: false,
        );

        expect(schema.validateIdJsonFollowsSchemaStructure({'count': 42}), isNull);
      });

      test('rejects non-integer value', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'count': SchemaPropertyInteger(nullable: false)},
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'count': 'not a number'}),
          contains('Expected int'),
        );
      });

      test('rejects double for integer field', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'count': SchemaPropertyInteger(nullable: false)},
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'count': 3.14}),
          contains('Expected int'),
        );
      });
    });

    group('double validation', () {
      test('accepts valid double', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'price': SchemaPropertyDouble(nullable: false)},
          nullable: false,
        );

        expect(schema.validateIdJsonFollowsSchemaStructure({'price': 19.99}), isNull);
      });

      test('accepts integer for double field', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'price': SchemaPropertyDouble(nullable: false)},
          nullable: false,
        );

        expect(schema.validateIdJsonFollowsSchemaStructure({'price': 20}), isNull);
      });

      test('rejects non-numeric value', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'price': SchemaPropertyDouble(nullable: false)},
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'price': 'expensive'}),
          contains('Expected num'),
        );
      });
    });

    group('boolean validation', () {
      test('accepts true', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'active': SchemaPropertyBoolean(nullable: false)},
          nullable: false,
        );

        expect(schema.validateIdJsonFollowsSchemaStructure({'active': true}), isNull);
      });

      test('accepts false', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'active': SchemaPropertyBoolean(nullable: false)},
          nullable: false,
        );

        expect(schema.validateIdJsonFollowsSchemaStructure({'active': false}), isNull);
      });

      test('rejects non-boolean value', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'active': SchemaPropertyBoolean(nullable: false)},
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'active': 'yes'}),
          contains('Expected bool'),
        );
      });

      test('rejects 1/0 for boolean', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {'active': SchemaPropertyBoolean(nullable: false)},
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'active': 1}),
          contains('Expected bool'),
        );
      });
    });

    group('enum validation', () {
      test('accepts valid enum value', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'status': SchemaPropertyEnum(
              enumValues: ['PENDING', 'APPROVED', 'REJECTED'],
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(schema.validateIdJsonFollowsSchemaStructure({'status': 'PENDING'}), isNull);
      });

      test('rejects invalid enum value', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'status': SchemaPropertyEnum(
              enumValues: ['PENDING', 'APPROVED', 'REJECTED'],
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'status': 'UNKNOWN'}),
          allOf(contains('Invalid enum value'), contains('UNKNOWN')),
        );
      });

      test('rejects non-string for enum', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'status': SchemaPropertyEnum(
              enumValues: ['PENDING', 'APPROVED'],
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'status': 0}),
          contains('Expected String'),
        );
      });
    });

    group('array validation', () {
      test('accepts valid array', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'tags': SchemaPropertyArray(
              items: SchemaPropertyString(nullable: false),
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'tags': ['a', 'b', 'c']}),
          isNull,
        );
      });

      test('accepts empty array', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'tags': SchemaPropertyArray(
              items: SchemaPropertyString(nullable: false),
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'tags': <String>[]}),
          isNull,
        );
      });

      test('rejects non-array value', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'tags': SchemaPropertyArray(
              items: SchemaPropertyString(nullable: false),
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'tags': 'not an array'}),
          contains('Expected List'),
        );
      });

      test('validates array item types', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'numbers': SchemaPropertyArray(
              items: SchemaPropertyInteger(nullable: false),
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'numbers': [1, 'two', 3]}),
          allOf(contains('Expected int'), contains('[1]')),
        );
      });

      test('validates nested array', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'matrix': SchemaPropertyArray(
              items: SchemaPropertyArray(
                items: SchemaPropertyInteger(nullable: false),
                nullable: false,
              ),
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({
            'matrix': [
              [1, 2],
              [3, 'invalid'],
            ]
          }),
          allOf(contains('Expected int'), contains('[1][1]')),
        );
      });
    });

    group('object validation', () {
      test('accepts valid nested object', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'user': SchemaPropertyStructuredObjectWithDefinedProperties(
              properties: {
                'name': SchemaPropertyString(nullable: false),
                'age': SchemaPropertyInteger(nullable: true),
              },
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({
            'user': {'name': 'John', 'age': 30}
          }),
          isNull,
        );
      });

      test('rejects non-object value', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'config': SchemaPropertyStructuredObjectWithDefinedProperties(
              properties: {},
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'config': 'not an object'}),
          contains('Expected Map<String, dynamic>'),
        );
      });

      test('validates nested object properties', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'user': SchemaPropertyStructuredObjectWithDefinedProperties(
              properties: {
                'id': SchemaPropertyInteger(nullable: false),
              },
              nullable: false,
            ),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({
            'user': {'id': 'not-an-int'}
          }),
          allOf(contains('Expected int'), contains('.user.id')),
        );
      });
    });

    group('required field validation', () {
      test('rejects missing required field', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'required': SchemaPropertyString(nullable: false),
            'optional': SchemaPropertyString(nullable: true),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'optional': 'value'}),
          allOf(contains('Missing required field'), contains('required')),
        );
      });

      test('accepts missing nullable field', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'required': SchemaPropertyString(nullable: false),
            'optional': SchemaPropertyString(nullable: true),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'required': 'value'}),
          isNull,
        );
      });
    });

    group('dynamic object validation', () {
      test('accepts any map for undefined properties object', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'data': SchemaPropertyObjectWithUndefinedProperties(nullable: false),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({
            'data': {'anything': 'goes', 'nested': {'also': 'works'}}
          }),
          isNull,
        );
      });

      test('rejects non-map for undefined properties object', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'data': SchemaPropertyObjectWithUndefinedProperties(nullable: false),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({'data': 'not a map'}),
          contains('Expected Map<String, dynamic>'),
        );
      });
    });

    group('complex schema validation', () {
      test('validates complete user profile schema', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'id': SchemaPropertyInteger(nullable: false),
            'username': SchemaPropertyString(nullable: false),
            'email': SchemaPropertyString(nullable: false),
            'status': SchemaPropertyEnum(
              enumValues: ['ACTIVE', 'INACTIVE', 'BANNED'],
              nullable: false,
            ),
            'roles': SchemaPropertyArray(
              items: SchemaPropertyString(nullable: false),
              nullable: false,
            ),
            'profile': SchemaPropertyStructuredObjectWithDefinedProperties(
              properties: {
                'firstName': SchemaPropertyString(nullable: false),
                'lastName': SchemaPropertyString(nullable: false),
                'bio': SchemaPropertyString(nullable: true),
                'age': SchemaPropertyInteger(nullable: true),
              },
              nullable: true,
            ),
            'settings': SchemaPropertyObjectWithUndefinedProperties(nullable: true),
          },
          nullable: false,
        );

        final validData = {
          'id': 1,
          'username': 'johndoe',
          'email': 'john@example.com',
          'status': 'ACTIVE',
          'roles': ['USER', 'MODERATOR'],
          'profile': {
            'firstName': 'John',
            'lastName': 'Doe',
            'bio': null,
            'age': 30,
          },
          'settings': {'theme': 'dark', 'notifications': true},
        };

        expect(schema.validateIdJsonFollowsSchemaStructure(validData), isNull);
      });

      test('reports first error in complex validation', () {
        final schema = SchemaPropertyStructuredObjectWithDefinedProperties(
          properties: {
            'id': SchemaPropertyInteger(nullable: false),
            'name': SchemaPropertyString(nullable: false),
          },
          nullable: false,
        );

        expect(
          schema.validateIdJsonFollowsSchemaStructure({
            'id': 'not-int',
            'name': 123,
          }),
          contains('Expected int'),
        );
      });
    });
  });

  group('toString', () {
    test('SchemaProperty toString returns formatted JSON', () {
      final prop = SchemaPropertyString(
        nullable: true,
        description: 'Test',
        shouldBeTranslated: true,
      );
      final str = prop.toString();

      expect(str, contains('"type": "string"'));
      expect(str, contains('"nullable": true'));
      expect(str, contains('"description": "Test"'));
      expect(str, contains('"shouldBeTranslated": true'));
    });

    test('SchemaDefinition toString returns formatted JSON', () {
      final def = SchemaDefinition(properties: {
        'field': SchemaPropertyInteger(nullable: false),
      });
      final str = def.toString();

      expect(str, contains('"field"'));
      expect(str, contains('"type": "integer"'));
    });
  });

  group('factory constructors', () {
    test('SchemaProperty.text creates SchemaPropertyString', () {
      final prop = SchemaProperty.text(nullable: false, shouldBeTranslated: true);

      expect(prop, isA<SchemaPropertyString>());
      expect((prop as SchemaPropertyString).shouldBeTranslated, true);
    });

    test('SchemaProperty.integer creates SchemaPropertyInteger', () {
      final prop = SchemaProperty.integer(nullable: true, description: 'Count');

      expect(prop, isA<SchemaPropertyInteger>());
      expect(prop.nullable, true);
      expect(prop.description, 'Count');
    });

    test('SchemaProperty.double creates SchemaPropertyDouble', () {
      final prop = SchemaProperty.double(nullable: false);

      expect(prop, isA<SchemaPropertyDouble>());
    });

    test('SchemaProperty.boolean creates SchemaPropertyBoolean', () {
      final prop = SchemaProperty.boolean(nullable: true);

      expect(prop, isA<SchemaPropertyBoolean>());
    });

    test('SchemaProperty.enumeration creates SchemaPropertyEnum', () {
      final prop = SchemaProperty.enumeration(
        enumValues: ['A', 'B'],
        nullable: false,
      );

      expect(prop, isA<SchemaPropertyEnum>());
      expect((prop as SchemaPropertyEnum).enumValues, ['A', 'B']);
    });

    test('SchemaProperty.array creates SchemaPropertyArray', () {
      final prop = SchemaProperty.array(
        items: SchemaPropertyString(nullable: false),
        nullable: false,
      );

      expect(prop, isA<SchemaPropertyArray>());
    });

    test('SchemaProperty.structuredObject creates structured object', () {
      final prop = SchemaProperty.structuredObject(
        properties: {'id': SchemaPropertyInteger(nullable: false)},
        nullable: false,
      );

      expect(prop, isA<SchemaPropertyStructuredObjectWithDefinedProperties>());
    });

    test('SchemaProperty.objectWithUndefinedProperties creates dynamic object', () {
      final prop = SchemaProperty.objectWithUndefinedProperties(nullable: true);

      expect(prop, isA<SchemaPropertyObjectWithUndefinedProperties>());
    });
  });
}

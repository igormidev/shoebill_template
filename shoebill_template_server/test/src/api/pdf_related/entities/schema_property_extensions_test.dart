import 'package:test/test.dart';
import 'package:get_it/get_it.dart';
import 'package:shoebill_template_server/src/services/ai_services.dart'
    as ai_svc;
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'dart:convert';

class MockOpenAiService implements ai_svc.IOpenAiService {
  Map<String, String>? mockTranslationResult;

  /// Captures the texts that were sent for translation
  Map<String, String>? lastTextsToTranslate;

  final List<ai_svc.AiChatMessage> _history = [];

  @override
  List<ai_svc.AiChatMessage> get history => List.unmodifiable(_history);

  @override
  void clearHistory() {
    _history.clear();
  }

  @override
  Future<String> generatePrompt({
    String model = '',
    required String prompt,
  }) async {
    throw UnimplementedError('Not needed for these tests');
  }

  @override
  Future<Map<String, String>> translateTexts({
    required Map<String, String> textsToTranslate,
    required String sourceLanguage,
    required String targetLanguage,
    String? model,
  }) async {
    lastTextsToTranslate = textsToTranslate;
    if (mockTranslationResult != null) {
      return mockTranslationResult!;
    }
    // Default: return same keys with "[TRANSLATED]" prefix on values
    return textsToTranslate.map((k, v) => MapEntry(k, '[TRANSLATED] $v'));
  }

  @override
  Stream<ai_svc.AiStreamResult> streamPromptGeneration({
    required String prompt,
    bool shouldUseInternetSearchTool = false,
    String? model,
  }) async* {
    throw UnimplementedError('Not needed for these tests');
  }

  @override
  Stream<ai_svc.AiStreamResult> streamPromptGenerationWithSchemaResponse({
    required String prompt,
    required Map<String, SchemaProperty> properties,
    bool shouldUseInternetSearchTool = false,
    String? model,
    int maxRetries = 2,
  }) async* {
    throw UnimplementedError('Not needed for these tests');
  }
}

void main() {
  late MockOpenAiService mockOpenAiService;

  setUp(() {
    mockOpenAiService = MockOpenAiService();
    GetIt.instance.registerSingleton<ai_svc.IOpenAiService>(mockOpenAiService);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('translateBasedOnSchema', () {
    test('translates a simple object with one translatable string', () async {
      // Schema with a single translatable string property
      final schema = SchemaDefinition(
        properties: {
          'title': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
        },
      );

      final inputJson = jsonEncode({'title': 'Hello World'});

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.spanish,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;
      expect(resultMap['title'], equals('[TRANSLATED] Hello World'));
    });

    test('translates nested objects', () async {
      // Schema with nested object containing translatable strings
      final schema = SchemaDefinition(
        properties: {
          'document': SchemaPropertyStructuredObjectWithDefinedProperties(
            nullable: false,
            properties: {
              'header': SchemaPropertyString(
                nullable: false,
                shouldBeTranslated: true,
              ),
              'body': SchemaPropertyStructuredObjectWithDefinedProperties(
                nullable: false,
                properties: {
                  'content': SchemaPropertyString(
                    nullable: false,
                    shouldBeTranslated: true,
                  ),
                },
              ),
            },
          ),
        },
      );

      final inputJson = jsonEncode({
        'document': {
          'header': 'Welcome',
          'body': {
            'content': 'This is the body text',
          },
        },
      });

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.french,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;
      final document = resultMap['document'] as Map<String, dynamic>;
      final body = document['body'] as Map<String, dynamic>;

      expect(document['header'], equals('[TRANSLATED] Welcome'));
      expect(body['content'], equals('[TRANSLATED] This is the body text'));
    });

    test('translates arrays with translatable items', () async {
      // Schema with array of translatable strings
      final schema = SchemaDefinition(
        properties: {
          'items': SchemaPropertyArray(
            nullable: false,
            items: SchemaPropertyString(
              nullable: false,
              shouldBeTranslated: true,
            ),
          ),
        },
      );

      final inputJson = jsonEncode({
        'items': ['Apple', 'Banana', 'Cherry'],
      });

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.german,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;
      final items = resultMap['items'] as List<dynamic>;

      expect(items[0], equals('[TRANSLATED] Apple'));
      expect(items[1], equals('[TRANSLATED] Banana'));
      expect(items[2], equals('[TRANSLATED] Cherry'));
    });

    test('translates arrays with translatable objects', () async {
      // Schema with array of objects containing translatable strings
      final schema = SchemaDefinition(
        properties: {
          'products': SchemaPropertyArray(
            nullable: false,
            items: SchemaPropertyStructuredObjectWithDefinedProperties(
              nullable: false,
              properties: {
                'name': SchemaPropertyString(
                  nullable: false,
                  shouldBeTranslated: true,
                ),
                'price': SchemaPropertyDouble(nullable: false),
              },
            ),
          ),
        },
      );

      final inputJson = jsonEncode({
        'products': [
          {'name': 'Laptop', 'price': 999.99},
          {'name': 'Phone', 'price': 599.99},
        ],
      });

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.japanese,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;
      final products = resultMap['products'] as List<dynamic>;

      expect(products[0]['name'], equals('[TRANSLATED] Laptop'));
      expect(products[0]['price'], equals(999.99));
      expect(products[1]['name'], equals('[TRANSLATED] Phone'));
      expect(products[1]['price'], equals(599.99));
    });

    test(
      'does NOT include non-translatable strings in the translation call',
      () async {
        // Schema with both translatable and non-translatable strings
        final schema = SchemaDefinition(
          properties: {
            'title': SchemaPropertyString(
              nullable: false,
              shouldBeTranslated: true,
            ),
            'id': SchemaPropertyString(
              nullable: false,
              shouldBeTranslated: false,
            ),
            'code': SchemaPropertyString(
              nullable: false,
              shouldBeTranslated: false,
            ),
          },
        );

        final inputJson = jsonEncode({
          'title': 'Product Name',
          'id': 'SKU-12345',
          'code': 'ABC-001',
        });

        await schema.translateBasedOnSchema(
          stringifiedJson: inputJson,
          sourceLanguage: SupportedLanguage.english,
          targetLanguage: SupportedLanguage.spanish,
        );

        // Verify only the translatable string was sent for translation
        expect(mockOpenAiService.lastTextsToTranslate, isNotNull);
        expect(mockOpenAiService.lastTextsToTranslate!.length, equals(1));
        expect(
          mockOpenAiService.lastTextsToTranslate!.containsKey('root.title'),
          isTrue,
        );
        expect(
          mockOpenAiService.lastTextsToTranslate!.containsKey('root.id'),
          isFalse,
        );
        expect(
          mockOpenAiService.lastTextsToTranslate!.containsKey('root.code'),
          isFalse,
        );
      },
    );

    test('preserves the original JSON structure', () async {
      // Schema with various property types
      final schema = SchemaDefinition(
        properties: {
          'name': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
          'count': SchemaPropertyInteger(nullable: false),
          'price': SchemaPropertyDouble(nullable: false),
          'active': SchemaPropertyBoolean(nullable: false),
          'status': SchemaPropertyEnum(
            nullable: false,
            enumValues: ['pending', 'active', 'completed'],
          ),
          'metadata': SchemaPropertyObjectWithUndefinedProperties(
            nullable: true,
          ),
        },
      );

      final inputJson = jsonEncode({
        'name': 'Test Item',
        'count': 42,
        'price': 19.99,
        'active': true,
        'status': 'active',
        'metadata': {'key1': 'value1', 'key2': 123},
      });

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.italian,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;

      // Translatable string should be translated
      expect(resultMap['name'], equals('[TRANSLATED] Test Item'));

      // Non-translatable types should be preserved exactly
      expect(resultMap['count'], equals(42));
      expect(resultMap['price'], equals(19.99));
      expect(resultMap['active'], equals(true));
      expect(resultMap['status'], equals('active'));
      expect(resultMap['metadata'], equals({'key1': 'value1', 'key2': 123}));
    });

    test('returns original JSON when no translatable strings exist', () async {
      // Schema with no translatable strings
      final schema = SchemaDefinition(
        properties: {
          'id': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: false,
          ),
          'count': SchemaPropertyInteger(nullable: false),
        },
      );

      final inputJson = jsonEncode({
        'id': 'test-123',
        'count': 5,
      });

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.spanish,
      );

      // Should return original JSON unchanged
      expect(result, equals(inputJson));

      // Translation service should not have been called
      expect(mockOpenAiService.lastTextsToTranslate, isNull);
    });

    test('handles empty strings in translatable fields', () async {
      final schema = SchemaDefinition(
        properties: {
          'title': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
          'description': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
        },
      );

      final inputJson = jsonEncode({
        'title': 'Hello',
        'description': '', // Empty string should not be translated
      });

      await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.spanish,
      );

      // Only non-empty translatable string should be sent
      expect(mockOpenAiService.lastTextsToTranslate!.length, equals(1));
      expect(
        mockOpenAiService.lastTextsToTranslate!.containsKey('root.title'),
        isTrue,
      );
      expect(
        mockOpenAiService.lastTextsToTranslate!.containsKey('root.description'),
        isFalse,
      );
    });

    test('handles null values in nullable fields', () async {
      final schema = SchemaDefinition(
        properties: {
          'title': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
          'subtitle': SchemaPropertyString(
            nullable: true,
            shouldBeTranslated: true,
          ),
        },
      );

      final inputJson = jsonEncode({
        'title': 'Main Title',
        'subtitle': null,
      });

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.spanish,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;

      expect(resultMap['title'], equals('[TRANSLATED] Main Title'));
      expect(resultMap['subtitle'], isNull);
    });

    test('uses mock translation result when provided', () async {
      final schema = SchemaDefinition(
        properties: {
          'greeting': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
        },
      );

      // Set up a specific mock translation result
      mockOpenAiService.mockTranslationResult = {
        'root.greeting': 'Hola Mundo',
      };

      final inputJson = jsonEncode({'greeting': 'Hello World'});

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.spanish,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;
      expect(resultMap['greeting'], equals('Hola Mundo'));
    });

    test('throws ShoebillException for invalid JSON input', () async {
      final schema = SchemaDefinition(
        properties: {
          'title': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
        },
      );

      expect(
        () => schema.translateBasedOnSchema(
          stringifiedJson: 'not valid json',
          sourceLanguage: SupportedLanguage.english,
          targetLanguage: SupportedLanguage.spanish,
        ),
        throwsA(isA<ShoebillException>()),
      );
    });

    test('preserves keys not in schema', () async {
      // Schema only defines 'title', but input has extra key 'extraField'
      final schema = SchemaDefinition(
        properties: {
          'title': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
        },
      );

      final inputJson = jsonEncode({
        'title': 'Hello',
        'extraField': 'This is not in schema',
      });

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.spanish,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;

      // Translatable field should be translated
      expect(resultMap['title'], equals('[TRANSLATED] Hello'));
      // Extra field should be preserved as-is
      expect(resultMap['extraField'], equals('This is not in schema'));
    });

    test('handles deeply nested arrays of objects', () async {
      final schema = SchemaDefinition(
        properties: {
          'categories': SchemaPropertyArray(
            nullable: false,
            items: SchemaPropertyStructuredObjectWithDefinedProperties(
              nullable: false,
              properties: {
                'name': SchemaPropertyString(
                  nullable: false,
                  shouldBeTranslated: true,
                ),
                'subcategories': SchemaPropertyArray(
                  nullable: false,
                  items: SchemaPropertyStructuredObjectWithDefinedProperties(
                    nullable: false,
                    properties: {
                      'name': SchemaPropertyString(
                        nullable: false,
                        shouldBeTranslated: true,
                      ),
                    },
                  ),
                ),
              },
            ),
          ),
        },
      );

      final inputJson = jsonEncode({
        'categories': [
          {
            'name': 'Electronics',
            'subcategories': [
              {'name': 'Phones'},
              {'name': 'Laptops'},
            ],
          },
          {
            'name': 'Clothing',
            'subcategories': [
              {'name': 'Shirts'},
            ],
          },
        ],
      });

      final result = await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.korean,
      );

      final resultMap = jsonDecode(result) as Map<String, dynamic>;
      final categories = resultMap['categories'] as List<dynamic>;

      expect(categories[0]['name'], equals('[TRANSLATED] Electronics'));
      expect(
        categories[0]['subcategories'][0]['name'],
        equals('[TRANSLATED] Phones'),
      );
      expect(
        categories[0]['subcategories'][1]['name'],
        equals('[TRANSLATED] Laptops'),
      );
      expect(categories[1]['name'], equals('[TRANSLATED] Clothing'));
      expect(
        categories[1]['subcategories'][0]['name'],
        equals('[TRANSLATED] Shirts'),
      );
    });

    test('correctly builds path keys for translation map', () async {
      final schema = SchemaDefinition(
        properties: {
          'title': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: true,
          ),
          'nested': SchemaPropertyStructuredObjectWithDefinedProperties(
            nullable: false,
            properties: {
              'description': SchemaPropertyString(
                nullable: false,
                shouldBeTranslated: true,
              ),
            },
          ),
          'items': SchemaPropertyArray(
            nullable: false,
            items: SchemaPropertyString(
              nullable: false,
              shouldBeTranslated: true,
            ),
          ),
        },
      );

      final inputJson = jsonEncode({
        'title': 'Main',
        'nested': {'description': 'Nested desc'},
        'items': ['Item1', 'Item2'],
      });

      await schema.translateBasedOnSchema(
        stringifiedJson: inputJson,
        sourceLanguage: SupportedLanguage.english,
        targetLanguage: SupportedLanguage.spanish,
      );

      // Verify the correct path keys were generated
      final textsToTranslate = mockOpenAiService.lastTextsToTranslate!;
      expect(textsToTranslate.containsKey('root.title'), isTrue);
      expect(textsToTranslate.containsKey('root.nested.description'), isTrue);
      expect(textsToTranslate.containsKey('root.items[0]'), isTrue);
      expect(textsToTranslate.containsKey('root.items[1]'), isTrue);
    });
  });
}

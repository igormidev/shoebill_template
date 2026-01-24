import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/server.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/ai_services.dart';

class CreateTemplateEssentialsEndpoint extends Endpoint {
  /// Creates template essentials from a JSON payload.
  /// The AI will analyze the payload and generate:
  /// - A title and description for the template
  /// - A schema definition that matches the JSON structure
  /// - A suggested prompt for Jinja2 HTML/CSS template generation
  /// - The detected reference language
  ///
  /// Returns a stream that yields either:
  /// - [TemplateEssentialThinkingResult] during AI reasoning
  /// - [TemplateEssentialFinalResult] when the final result is ready
  Stream<CreateTemplateEssentialsResult> call(
    Session session, {
    required String stringifiedPayload,
  }) async* {
    final Map<String, dynamic>? payload = tryDecode(stringifiedPayload);
    if (payload == null) {
      throw ShoebillException(
        title: 'Invalid JSON',
        description:
            'The provided payload is not valid JSON. Please check the format and try again.',
      );
    }

    final prettyVersionOfJsonForPrompt = JsonEncoder.withIndent(
      '  ',
    ).convert(payload);

    // Create a new AI service instance with its own chat history
    final aiServiceFactory = getIt<OpenAiServiceFactory>();
    final aiService = aiServiceFactory();

    final prompt = _buildAnalysisPrompt(prettyVersionOfJsonForPrompt);

    final schemaProperties = _buildResponseSchemaProperties();

    await for (final result
        in aiService.streamPromptGenerationWithSchemaResponse(
          prompt: prompt,
          properties: schemaProperties,
        )) {
      if (result is AiSchemaThinkItem) {
        yield TemplateEssentialThinkingResult(
          thinkingChunk: result.thinkingChunk,
        );
      } else if (result is AiSchemaResultItem) {
        final templateEssential = _parseTemplateEssentialFromAiResponse(
          result.result,
        );
        yield TemplateEssentialFinalResult(template: templateEssential);
      }
    }
  }

  /// Builds the sophisticated prompt for analyzing the JSON payload
  String _buildAnalysisPrompt(String prettyJson) {
    final languageNames =
        SupportedLanguages.values.map((e) => e.name).toList();
    return '''
You are an expert PDF template architect and JSON schema analyst. Your task is to analyze a user-provided JSON payload and generate comprehensive template essentials for a Jinja2-based HTML/CSS PDF generation system.

## INPUT JSON PAYLOAD
```json
$prettyJson
```

## YOUR MISSION

Analyze the above JSON payload exhaustively and generate:

1. **Template Metadata** (pdfContent):
   - `name`: A concise, descriptive title (3-7 words) that captures what this PDF template is for
   - `description`: A clear 1-2 sentence description explaining what documents this template will generate

2. **Schema Definition** (schemaDefinition):
   Create a precise schema that matches the JSON structure. For each field, determine:
   - The data type (string, integer, double, boolean, enum, array, or structured_object)
   - Whether the field should be translatable (for user-facing text content)
   - Appropriate descriptions for complex fields
   - For arrays, define the item schema
   - For nested objects, recursively define their properties

3. **Reference Language Detection** (referenceLanguage):
   Analyze ALL text content in the JSON to detect the primary language. Consider:
   - Field values that contain natural language text
   - The character sets and linguistic patterns used
   - Return the appropriate language code from the supported list

4. **Suggested Template Generation Prompt** (suggestedPrompt):
   This is CRITICAL. Generate an extremely detailed, comprehensive prompt that will be used by another AI to create an HTML template with embedded CSS and Jinja2 variables for PDF generation. The template will use the Jinja2 template engine for dynamic content rendering. This prompt must be OUTSTANDING.

## SUGGESTED PROMPT REQUIREMENTS

The suggested prompt MUST include detailed instructions for creating an HTML/CSS template with Jinja2 syntax for variables:

### Document Structure Analysis
- Identify if there are arrays that should generate SEPARATE PAGES for each item
- Determine the logical page structure (cover page, content pages, summary page, etc.)
- Define page numbering strategy using CSS @page rules and Jinja2 logic

### Header/Footer Configuration
- Should there be headers? On which pages?
- Should there be footers? On which pages?
- What content belongs in headers/footers (page numbers, dates, titles, logos)?
- Define which pages should have NO header/footer (like cover pages)
- Use CSS @page margin boxes or fixed-position elements for headers/footers

### Content Layout Instructions
- How to visually separate sections (CSS borders, spacing, boxes, colors)
- Text alignment for different content types (titles centered, body left-aligned, etc.)
- Font size hierarchy (headings vs body vs captions) using CSS
- Margin and padding specifications
- CSS Grid or Flexbox layouts if applicable
- Use "Noto Sans CJK" as the default font family for multi-language support

### Dynamic Content Handling with Jinja2
- For EACH array in the JSON: Use Jinja2 `{% for item in items %}` loops
- Should each item become a new page (with CSS `page-break-before`)? A new section? A table row?
- How to handle variable-length content (text wrapping, pagination via CSS)
- How to handle missing/null optional fields using Jinja2 `{% if field %}` conditionals

### Multi-Language Support
- ALL hardcoded strings in the template MUST support multiple languages
- Use Jinja2 conditionals for language switching: `{% if language == 'english' %}Text{% elif language == 'spanish' %}Texto{% endif %}`
- Every user-facing label, heading, and static text must have translations for all supported languages
- The `language` variable will always be passed to the template for language selection

### Image and Media Handling
- If any field contains URLs that COULD be images (check for .png, .jpg, .jpeg, .gif, .webp, .svg extensions or image hosting domains)
- Specify exact instructions: "If [field_path] contains an image URL, embed with `<img src="{{ field_path }}" />` at [position] with [dimensions]"
- Define image sizing via CSS, aspect ratio handling, and fallback behavior

### Data Presentation
- How to format dates, numbers, currencies using Jinja2 filters
- Table layouts for list data using HTML `<table>` with CSS styling
- Bullet points vs numbered lists using `<ul>`/`<ol>`
- Emphasis for important information (CSS font-weight, color, font-size)

### Styling Guidelines
- Color scheme suggestions based on content type defined in CSS
- Professional vs casual tone in layout
- Branding placeholder areas
- All styling MUST be in embedded CSS (`<style>` block), not inline styles

### Error Handling
- Use Jinja2 `{% if field %}` to check for missing data
- Fallback values using Jinja2 `{{ field | default('N/A') }}` filter
- Graceful degradation for missing images with CSS fallbacks

### Technical Requirements
- Page size (A4, Letter, etc.) defined via CSS `@page { size: A4; }`
- Orientation (portrait/landscape) via CSS `@page { size: A4 landscape; }`
- CSS print media rules for proper PDF rendering

## EXAMPLE OF A GREAT SUGGESTED PROMPT

For a JSON like `{"invoice": {"number": "INV-001", "items": [...], "customer": {...}}}`:

"Create an HTML template with embedded CSS and Jinja2 variables for a professional PDF invoice with the following specifications:

**Document Structure:**
- Page 1: Invoice header with company branding area (top 20%), invoice details, and customer information
- Subsequent pages: Continuation of line items table with simplified header
- All pages: Footer with page X of Y, invoice number, and generation date
- Use CSS `@page` rules for page sizing and margins

**Header Configuration:**
- First page: Full company header with logo placeholder (`<img>` tag, 150x50px, top-left), company name (24pt bold), and tagline
- Other pages: Minimal header with company name (12pt) and 'Invoice Continuation' label
- Use Jinja2 conditionals to vary header content per page

**Multi-Language Support:**
- All labels (e.g., 'Invoice', 'Date', 'Total', 'Quantity') must use Jinja2 conditionals for language switching
- Example: `{% if language == 'english' %}Invoice{% elif language == 'spanish' %}Factura{% elif language == 'french' %}Facture{% endif %}`
- Support all available languages in the system

**Line Items Table (from 'items' array):**
- Use `{% for item in invoice.items %}` to iterate
- Each item is a `<tr>` table row, NOT a separate page
- Columns: Item #, Description (40% width), Quantity (right-aligned), Unit Price (currency format), Total
- Zebra striping using CSS `:nth-child(even)` selector
- Use CSS `page-break-inside: avoid` on table rows

**Customer Section:**
- Display `{{ invoice.customer.name }}` in bold, address in regular weight
- Right-align customer block on first page using CSS

**Totals Section:**
- Right-aligned block after items table
- Show subtotal, tax (if present with `{% if invoice.tax %}`), and grand total
- Grand total in larger font (14pt bold)

**Styling (in `<style>` block):**
- Primary color: #2C3E50 for headers and accents
- Body text: #333333, 10pt, font-family: 'Noto Sans CJK', sans-serif
- Use CSS border-bottom (1px solid #CCCCCC) to separate sections
- `@page { size: A4; margin: 2cm; }`

**Image Handling:**
- If `items[].image_url` exists: `<img src="{{ item.image_url }}" style="width:40px;height:40px;object-fit:cover;" />`
- Fallback: Show item number in a colored circle using CSS border-radius"

## SUPPORTED LANGUAGES FOR referenceLanguage

Use EXACTLY one of these values:
${languageNames.join(', ')}

## SCHEMA TYPE DEFINITIONS

For schemaDefinition.properties, each property must have:
- `type`: One of: "string", "integer", "double", "boolean", "enum", "array", "dynamic_object_with_undefined_properties", "structured_object_with_defined_properties"
- `nullable`: boolean
- `description`: Optional string explaining the field
- For strings: `shouldBeTranslated`: boolean (true for user-facing text that should be localized)
- For enums: `possibleEnumValues`: array of possible string values
- For arrays: `items`: The schema for array items
- For structured_object_with_defined_properties: `properties`: Map of nested property schemas

## RESPONSE FORMAT

Respond with a JSON object containing exactly these fields:
- pdfContent: { name: string, description: string }
- schemaDefinition: { properties: { [key]: SchemaProperty } }
- suggestedPrompt: string (the detailed HTML/CSS template generation prompt with Jinja2 syntax instructions)
- referenceLanguage: string (one of the supported language values)

Be thorough, precise, and creative in your analysis. The quality of the suggested prompt directly impacts how well the Jinja2 HTML/CSS templates will be generated for PDF rendering.''';
  }

  /// Builds the schema properties for the expected AI response
  Map<String, SchemaProperty> _buildResponseSchemaProperties() {
    final languageNames =
        SupportedLanguages.values.map((e) => e.name).toList();
    return {
      'pdfContent': SchemaPropertyStructuredObjectWithDefinedProperties(
        nullable: false,
        description: 'Template metadata with name and description',
        properties: {
          'name': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: false,
            description: 'A concise title for the template (3-7 words)',
          ),
          'description': SchemaPropertyString(
            nullable: false,
            shouldBeTranslated: false,
            description: 'A clear description of what the template generates',
          ),
        },
      ),
      'schemaDefinition': SchemaPropertyStructuredObjectWithDefinedProperties(
        nullable: false,
        description: 'Schema definition matching the JSON structure',
        properties: {
          'properties': SchemaPropertyObjectWithUndefinedProperties(
            nullable: false,
            description:
                'Map of property names to their schema definitions. Each schema has type, nullable, and type-specific fields.',
          ),
        },
      ),
      'suggestedPrompt': SchemaPropertyString(
        nullable: false,
        shouldBeTranslated: false,
        description:
            'Detailed prompt for Jinja2 HTML/CSS template generation with all layout, styling, and multi-language support instructions',
      ),
      'referenceLanguage': SchemaPropertyEnum(
        nullable: false,
        description: 'The detected language of the content',
        enumValues: languageNames,
      ),
    };
  }

  /// Parses the AI response into a TemplateEssential object
  TemplateEssential _parseTemplateEssentialFromAiResponse(
    Map<String, dynamic> aiResponse,
  ) {
    try {
      // Parse pdfContent
      final pdfContentJson = aiResponse['pdfContent'] as Map<String, dynamic>;
      final pdfContent = PdfContent(
        name: pdfContentJson['name'] as String,
        description: pdfContentJson['description'] as String,
      );

      // Parse schemaDefinition
      final schemaDefJson =
          aiResponse['schemaDefinition'] as Map<String, dynamic>;
      final propertiesJson =
          schemaDefJson['properties'] as Map<String, dynamic>;
      final properties = _parseSchemaProperties(propertiesJson);
      final schemaDefinition = SchemaDefinition(properties: properties);

      // Parse suggestedPrompt
      final suggestedPrompt = aiResponse['suggestedPrompt'] as String;

      // Parse referenceLanguage
      final languageStr = aiResponse['referenceLanguage'] as String;
      final referenceLanguage = SupportedLanguages.fromJson(languageStr);

      return TemplateEssential(
        pdfContent: pdfContent,
        schemaDefinition: schemaDefinition,
        suggestedPrompt: suggestedPrompt,
        referenceLanguage: referenceLanguage,
      );
    } catch (e) {
      throw ShoebillException(
        title: 'AI Response Parsing Error',
        description:
            'Failed to parse template essentials from AI response: $e',
      );
    }
  }

  /// Recursively parses schema properties from JSON
  Map<String, SchemaProperty> _parseSchemaProperties(
    Map<String, dynamic> propertiesJson,
  ) {
    final result = <String, SchemaProperty>{};

    for (final entry in propertiesJson.entries) {
      final key = entry.key;
      final value = entry.value as Map<String, dynamic>;
      result[key] = _parseSchemaProperty(value);
    }

    return result;
  }

  /// Parses a single schema property from JSON
  SchemaProperty _parseSchemaProperty(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String;
      final nullable = json['nullable'] as bool? ?? false;
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
            nullable: nullable,
            description: description,
            enumValues: enumValues,
          );

        case 'array':
          final itemsJson = json['items'] as Map<String, dynamic>;
          return SchemaPropertyArray(
            nullable: nullable,
            description: description,
            items: _parseSchemaProperty(itemsJson),
          );

        case 'dynamic_object_with_undefined_properties':
          return SchemaPropertyObjectWithUndefinedProperties(
            nullable: nullable,
            description: description,
          );

        case 'structured_object_with_defined_properties':
          final nestedProperties =
              json['properties'] as Map<String, dynamic>;
          return SchemaPropertyStructuredObjectWithDefinedProperties(
            nullable: nullable,
            description: description,
            properties: _parseSchemaProperties(nestedProperties),
          );

        default:
          // Fallback to dynamic object for unknown types
          return SchemaPropertyObjectWithUndefinedProperties(
            nullable: nullable,
            description: description,
          );
      }
    } catch (e) {
      throw ShoebillException(
        title: 'AI Response Parsing Error',
        description:
            'Failed to parse schema property from AI response: $e',
      );
    }
  }
}

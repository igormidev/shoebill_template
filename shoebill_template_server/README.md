# Shoebill Template Server

A Serverpod backend for a SaaS platform that enables users to create, manage, and render multi-language PDF templates through AI-assisted template generation.

## What is This SaaS?

Shoebill Template is a PDF generation platform where users can:

1. **Create PDF Templates** - Provide a JSON payload example and let AI generate HTML/CSS templates with Jinja2 syntax
2. **Multi-Language Support** - Automatically translate PDFs into 23+ languages with AI-powered translation
3. **Version Management** - Track template versions with smart versioning (UI-only changes vs schema changes)
4. **REST API Access** - Get a dedicated endpoint to generate PDFs by simply POSTing your data

## Core Concepts

### Template Hierarchy

The system uses a hierarchical structure for organizing templates:

```
ShoebillTemplateScaffold (Root - general info, title, description)
    └── ShoebillTemplateVersion (Version with schema and HTML/CSS)
            ├── ShoebillTemplateVersionInput (HTML/CSS content)
            └── ShoebillTemplateBaseline (Concrete implementation with payload)
                    └── ShoebillTemplateBaselineImplementation (Language-specific translation)
```

**Key Entities:**

- **@shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_scaffold.spy.yaml** - The root entity containing template metadata (name, description)
- **@shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_version.spy.yaml** - A specific version of a template (created when schema changes)
- **@shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_version_input.spy.yaml** - The HTML and CSS content for a version
- **@shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_baseline.spy.yaml** - A concrete PDF created from a version with a specific payload
- **@shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_baseline_implementation.spy.yaml** - Language-specific translated version of a baseline

### Versioning Logic

- **UI-Only Changes** - When a user modifies colors, fonts, layout (no schema change), the existing ShoebillTemplateVersion is updated in place. Existing PDFs continue to work and get the visual updates.
- **Schema Changes** - When the JSON schema changes (new fields, removed fields, type changes), a NEW ShoebillTemplateVersion is created under the same scaffold. Old PDFs use the old version, new PDFs use the new version.

### Multi-Language Translation

The system supports 23 languages defined in @shoebill_template_server/lib/src/entities/others/supported_languages.spy.yaml:
- English, Spanish, French, German, Italian, Portuguese (Brazil/Portugal)
- Simplified/Traditional Chinese, Japanese, Korean
- Russian, Ukrainian, Polish, Czech, Romanian, Swedish, Dutch
- Indonesian, Malay, Filipino, Turkish, Swahili

**Translation Strategy:**
1. **Hardcoded strings** - Translated in the HTML template using Jinja2 conditionals based on language variable
2. **Payload data** - Translated in real-time by AI (only strings marked with SchemaProperty.shouldBeTranslated = true)
3. **Parallel Translation** - Multiple strings are translated concurrently using batched requests

## Architecture

### Main Services

**AI-Powered Template Generation:**
- **@shoebill_template_server/lib/src/services/daytona_claude_code_service.dart** - Manages Claude Code instances in Daytona sandboxes to generate Jinja2 HTML/CSS templates
- **@shoebill_template_server/lib/src/services/template_reviewer_service.dart** - AI reviewer that validates generated templates (syntax, schema compliance, multi-language support)
- **@shoebill_template_server/lib/src/services/ai_services.dart** - OpenRouter AI service for translations and template analysis

**PDF Generation:**
- **@shoebill_template_server/lib/src/core/mixins/jinja_pdf_renderer_mixin.dart** - Jinja2 template rendering + headless Chrome PDF generation

**Controllers:**
- **@shoebill_template_server/lib/src/services/pdf_controller.dart** - Business logic for creating/updating templates, adding languages, managing versions

### Main Routes (API Endpoints)

**Template Creation & Management:**
- **@shoebill_template_server/lib/src/api/chat_session_related/chat_session_endpoint.dart** - WebSocket-style streaming endpoint for AI-assisted template creation/editing with chat interface
- **@shoebill_template_server/lib/src/api/chat_session_related/create_template_essentials_endpoint.dart** - Analyzes a JSON payload and generates template metadata (title, description, schema, suggested prompt)

**PDF Generation & Viewing:**
- **@shoebill_template_server/lib/src/api/pdf_related/pdf_generate_route.dart** - POST endpoint to create a new baseline (PDF instance) from a version + payload
- **@shoebill_template_server/lib/src/api/pdf_related/pdf_visualize_route.dart** - GET endpoint to view/download a PDF from a baseline UUID (handles language detection via IP or session)
- **@shoebill_template_server/lib/src/api/pdf_related/pdf_preview_route.dart** - POST endpoint for live preview during chat editing (accepts HTML/CSS/payload, returns PDF)

### Chat Session Flow

1. **User provides JSON payload** → create_template_essentials_endpoint analyzes it with AI
2. **AI generates**: Schema, title, description, reference language, suggested prompt
3. **User enters chat session** → chat_session_endpoint.startChatFromNewTemplate creates session
4. **User sends messages** → Chat controller calls Daytona Claude Code to generate/modify HTML/CSS
5. **Reviewer AI validates** → Max 6 retry attempts if issues found
6. **User deploys** → chat_session_endpoint.deploySession creates the full template hierarchy in database

## Key Features

### Jinja2 Template System

Templates use Jinja2 syntax for dynamic content:

```html
<h1>{{ document.title }}</h1>
{% for item in items %}
  <div>{{ item.name }} - ${{ item.price }}</div>
{% endfor %}

{% if language == "spanish" %}
  <p>Hola Mundo</p>
{% elif language == "french" %}
  <p>Bonjour le Monde</p>
{% else %}
  <p>Hello World</p>
{% endif %}
```

### Schema Definition & Validation

Powerful schema system with validation, translation extraction, and OpenRouter JSON Schema conversion. Supports: String, Integer, Double, Boolean, Enum, Array, Structured Objects, Dynamic Objects. Each string field can be marked shouldBeTranslated for automatic translation.

### AI-Powered Generation

**Three Prompt Scenarios:**
1. **Create New Template** - No existing HTML/CSS, generates from user description + schema
2. **Edit Existing Template** - Modifies existing HTML/CSS based on user feedback
3. **Change Schema** - Adapts template to accommodate new/removed/changed fields

**Reviewer Validation:**
- Checks Jinja2 syntax correctness
- Verifies all schema variables are used properly
- Ensures multi-language support (all 23 languages have hardcoded string translations)
- Validates proper use of Noto Sans CJK font
- Confirms page structure matches user requirements

## Configuration

Required API keys (set in environment or service initialization):
- DAYTONA_API_KEY - For Claude Code sandbox execution
- ANTHROPIC_API_KEY - For Claude API access
- OpenRouter API key - For translations and template analysis

## Important Next Step

**Run `serverpod generate`** to regenerate Dart protocol code from the updated .spy.yaml model definitions. This will resolve compilation issues related to stale generated code.

## Important Files Reference

### Core Business Logic
- @shoebill_template_server/lib/src/services/pdf_controller.dart
- @shoebill_template_server/lib/src/services/daytona_claude_code_service.dart
- @shoebill_template_server/lib/src/services/template_reviewer_service.dart

### API Endpoints
- @shoebill_template_server/lib/src/api/chat_session_related/chat_session_endpoint.dart
- @shoebill_template_server/lib/src/api/pdf_related/pdf_generate_route.dart
- @shoebill_template_server/lib/src/api/pdf_related/pdf_visualize_route.dart

### Utilities
- @shoebill_template_server/lib/src/core/mixins/jinja_pdf_renderer_mixin.dart
- @shoebill_template_server/lib/src/core/utils/consts.dart
- @shoebill_template_server/lib/src/api/pdf_related/entities/schema_property_extensions.dart

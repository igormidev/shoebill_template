# Shoebill Template

An AI-powered PDF template generator that transforms JSON data into beautifully formatted PDF documents through intelligent, collaborative template creation.

## Project Overview

Shoebill Template addresses a common challenge in document generation: creating professional PDF templates from structured data requires significant design and development effort. This application streamlines the process by leveraging AI to automatically generate Jinja2-based HTML/CSS templates that render JSON data into polished PDFs.

Users simply provide sample JSON data, and the AI generates a complete template with proper styling, layout, and formatting. Through an interactive chat interface, users can refine the template in real-time, seeing live PDF previews as changes are made. Once satisfied, templates can be deployed for production use.

## Key Features

- **AI-Powered Template Generation** - Automatically creates Jinja2 HTML/CSS templates from sample JSON data
- **Real-Time Collaboration** - Interactive chat interface for refining templates with AI assistance
- **Live PDF Preview** - See rendered PDF output update in real-time as the template evolves
- **Multi-Language Support** - Generate templates in different languages to support international use cases
- **Schema Validation** - Automatic validation and review of JSON data structure
- **Template Versioning** - Track changes and iterate on template designs
- **Production Deployment** - Deploy finalized templates for integration with other systems

## User Workflow

1. **Upload JSON Data** - Drag and drop or paste sample JSON data that represents your document structure
2. **Review Schema** - Validate and review the detected JSON schema to ensure proper field mapping
3. **Chat with AI** - Describe your desired layout, styling, and formatting through natural language
4. **Preview PDF** - View live PDF renders as the AI generates and refines the template
5. **Iterate and Refine** - Continue the conversation to adjust styling, add sections, or fix issues
6. **Deploy Template** - Finalize and deploy the template for production use

## Tech Stack

- **Frontend**: Flutter for cross-platform web application
- **Backend**: Serverpod for type-safe Dart server infrastructure
- **Templating**: Jinja2 for flexible HTML/CSS template generation
- **PDF Rendering**: Server-side PDF generation from HTML templates

---

## Architecture

The application follows clean architecture principles with:
- **Presentation Layer**: Flutter widgets and screens
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Serverpod client integration

```
shoebill_template_flutter/
├── lib/
│   ├── src/
│   │   ├── core/              # Core utilities and extensions
│   │   │   ├── extensions/    # Dart/Flutter extensions
│   │   │   ├── utils/         # Helper functions
│   │   │   └── constants/     # App constants
│   │   ├── design_system/     # UI components and theming
│   │   │   ├── theme/         # App theme configuration
│   │   │   ├── widgets/       # Reusable widgets
│   │   │   └── default_error_snackbar.dart
│   │   ├── features/          # Feature modules
│   │   │   ├── chat/  # AI chat interface
│   │   │   ├── landing_page/  # The landing page of the app
│   │   │   ├── template_listage/  # Template listage
│   │   │   ├── ... other features
│   │   │   └──  auth/          # Authentication/Splash-screen
│   │   └── routing/           # App navigation
│   └── main.dart             # App entry point
├── assets/                    # Images, fonts, etc.
├── web/                      # Web-specific files
└── pubspec.yaml
```


### Using toResult Extension
Always use the `toResult` extension for API calls:
```dart
// Make API call with proper error handling
final result = await client.example.endpointExample(request).toResult;

result.fold(
  (success) => _handleSuccess(success),
  (error) => handleBabelException(context, error),
);
```

### Error Handling in Dialogs
```dart
final result = await client.scraper.generateRules(request).toResult;

result.fold(
  (success) {
    Navigator.of(context).pop();
    // Handle success
  },
  (error) {
    Navigator.of(context).pop();
    handleBabelException(context, error);
  },
);
```

## 🐛 Common Issues

### "withOpacity is deprecated" Error
Always use `withAlpha()` instead:
```dart
// ✅ Correct
color.withAlpha(128)

// ❌ Wrong
color.withOpacity(0.5)
```

### Serverpod Generation Errors
Always include experimental features:
```bash
serverpod generate
```

### Widget Rebuild Performance
- Use `const` constructors
- Break down large widgets
- Use widget classes, not functions
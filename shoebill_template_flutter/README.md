

## 🏗️ Architecture

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
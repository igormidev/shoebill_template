# Translation Guide for Scoutbox

This guide explains how to add and manage translations in the Scoutbox Flutter application.

## Overview

Scoutbox uses Flutter's built-in localization system with ARB (Application Resource Bundle) files. The app currently supports three languages:
- English (en) - Reference language
- Portuguese (pt)
- Japanese (ja)

## File Structure

Translation files are located in:
```
lib/l10n/
├── app_en.arb    # English (reference)
├── app_pt.arb    # Portuguese
└── app_ja.arb    # Japanese
```

Generated localization code is in:
```
lib/gen_l10n/
└── s.dart        # Generated localization delegates
```

## Step-by-Step Translation Process

### 1. Add String to Reference File

First, add your new string to the English reference file `lib/l10n/app_en.arb`:

```json
{
    "league_level": "League Level",
    "behavioral_risk_description": "Behavioral Risk Description",
    "filter": "Filter"
}
```

**Important conventions:**
- Use snake_case for keys (e.g., `league_level`, not `leagueLevel`)
- Keep keys descriptive and organized
- Group related translations with comments:
  ```json
  "@_CoachSection": {
      "comment": "↓labels for coach features"
  },
  ```

### 2. Add Translations to Other Languages

Add the corresponding translations to each language file:

**Portuguese** (`lib/l10n/app_pt.arb`):
```json
{
    "league_level": "Nível da Liga",
    "behavioral_risk_description": "Descrição do Risco Comportamental",
    "filter": "Filtrar"
}
```

**Japanese** (`lib/l10n/app_ja.arb`):
```json
{
    "league_level": "リーグレベル",
    "behavioral_risk_description": "行動リスクの説明",
    "filter": "フィルター"
}
```

### 3. Generate Localization Code

Run the following command to generate the localization functions:

```bash
flutter gen-l10n
```

This creates/updates files in `lib/gen_l10n/` with type-safe accessors for your translations.

### 4. Use Translations in Code

Replace hardcoded strings with localized versions:

**Before:**
```dart
Text('League Level')
```

**After:**
```dart
import 'package:scoutbox/gen_l10n/s.dart';

Text(S.of(context)!.league_level)
```

## Special Features

### 1. Parameterized Translations

For dynamic content, use placeholders:

**ARB file:**
```json
{
    "player_age": "{value} years old",
    "@player_age": {
        "placeholders": {
            "value": {
                "type": "int"
            }
        }
    }
}
```

**Usage:**
```dart
Text(S.of(context)!.player_age(player.age))
```

### 2. Rich Text Support

For styled text, use special markers:
- `<pC>text<pC>` - Primary color
- `<b>text<b>` - Bold
- `<u>text<u>` - Underline

**Example:**
```json
{
    "highlight_text": "This is <pC>highlighted<pC> and <b>bold<b> text"
}
```

### 3. Multiline Strings

Use `\n` for line breaks:
```json
{
    "multi_line": "First line\\nSecond line"
}
```

## Best Practices

1. **Always use the English file as reference** - Add new keys here first
2. **Keep translations consistent** - Use the same terminology across the app
3. **Test all languages** - Switch app language to verify translations display correctly
4. **Group related translations** - Use comments to organize sections
5. **Handle missing translations** - The app falls back to English if a translation is missing

## Common Patterns

### UI Elements
```json
{
    "button_save": "Save",
    "button_cancel": "Cancel",
    "button_delete": "Delete",
    "label_name": "Name",
    "placeholder_search": "Search...",
    "title_settings": "Settings"
}
```

### Messages
```json
{
    "message_success": "Operation completed successfully",
    "message_error": "An error occurred",
    "message_loading": "Loading..."
}
```

### Form Validation
```json
{
    "validation_required": "This field is required",
    "validation_email": "Please enter a valid email",
    "validation_min_length": "Minimum {length} characters required",
    "@validation_min_length": {
        "placeholders": {
            "length": {"type": "int"}
        }
    }
}
```

## Troubleshooting

1. **Generated code not updating**
   - Delete `lib/gen_l10n/` folder
   - Run `flutter gen-l10n` again
   - Run `flutter clean` if needed

2. **Missing translations**
   - Check all language files have the same keys
   - Ensure JSON syntax is valid
   - Look for typos in key names

3. **Special characters**
   - Use Unicode escapes for special characters
   - Test thoroughly in all languages

## Quick Reference

| Task | Command/Location |
|------|-----------------|
| Add new string | Edit `lib/l10n/app_en.arb` first |
| Add translations | Edit `lib/l10n/app_pt.arb` and `lib/l10n/app_ja.arb` |
| Generate code | `flutter gen-l10n` |
| Use in widget | `S.of(context)!.your_key` |
| Import | `import 'package:scoutbox/gen_l10n/s.dart';` |

## Example: Adding a New Translation

Let's add a "Coach Level" translation:

1. **Add to English file** (`lib/l10n/app_en.arb`):
   ```json
   "coach_level": "Coach Level"
   ```

2. **Add to Portuguese** (`lib/l10n/app_pt.arb`):
   ```json
   "coach_level": "Nível do Treinador"
   ```

3. **Add to Japanese** (`lib/l10n/app_ja.arb`):
   ```json
   "coach_level": "コーチレベル"
   ```

4. **Generate code**:
   ```bash
   flutter gen-l10n
   ```

5. **Use in code**:
   ```dart
   Text(S.of(context)!.coach_level)
   ```

That's it! Your string is now properly localized across all supported languages.
/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

enum SupportedLanguage implements _i1.SerializableModel {
  english,
  simplifiedMandarinChinese,
  traditionalChinese,
  spanish,
  french,
  brazilianPortuguese,
  portugalPortuguese,
  russian,
  ukrainian,
  polish,
  indonesian,
  malay,
  german,
  dutch,
  japanese,
  swahili,
  turkish,
  vietnamese,
  korean,
  italian,
  filipino,
  romanian,
  swedish,
  czech;

  static SupportedLanguage fromJson(String name) {
    switch (name) {
      case 'english':
        return SupportedLanguage.english;
      case 'simplifiedMandarinChinese':
        return SupportedLanguage.simplifiedMandarinChinese;
      case 'traditionalChinese':
        return SupportedLanguage.traditionalChinese;
      case 'spanish':
        return SupportedLanguage.spanish;
      case 'french':
        return SupportedLanguage.french;
      case 'brazilianPortuguese':
        return SupportedLanguage.brazilianPortuguese;
      case 'portugalPortuguese':
        return SupportedLanguage.portugalPortuguese;
      case 'russian':
        return SupportedLanguage.russian;
      case 'ukrainian':
        return SupportedLanguage.ukrainian;
      case 'polish':
        return SupportedLanguage.polish;
      case 'indonesian':
        return SupportedLanguage.indonesian;
      case 'malay':
        return SupportedLanguage.malay;
      case 'german':
        return SupportedLanguage.german;
      case 'dutch':
        return SupportedLanguage.dutch;
      case 'japanese':
        return SupportedLanguage.japanese;
      case 'swahili':
        return SupportedLanguage.swahili;
      case 'turkish':
        return SupportedLanguage.turkish;
      case 'vietnamese':
        return SupportedLanguage.vietnamese;
      case 'korean':
        return SupportedLanguage.korean;
      case 'italian':
        return SupportedLanguage.italian;
      case 'filipino':
        return SupportedLanguage.filipino;
      case 'romanian':
        return SupportedLanguage.romanian;
      case 'swedish':
        return SupportedLanguage.swedish;
      case 'czech':
        return SupportedLanguage.czech;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SupportedLanguage"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

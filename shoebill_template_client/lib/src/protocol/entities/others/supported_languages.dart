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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

enum SupportedLanguages implements _i1.SerializableModel {
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

  static SupportedLanguages fromJson(String name) {
    switch (name) {
      case 'english':
        return SupportedLanguages.english;
      case 'simplifiedMandarinChinese':
        return SupportedLanguages.simplifiedMandarinChinese;
      case 'traditionalChinese':
        return SupportedLanguages.traditionalChinese;
      case 'spanish':
        return SupportedLanguages.spanish;
      case 'french':
        return SupportedLanguages.french;
      case 'brazilianPortuguese':
        return SupportedLanguages.brazilianPortuguese;
      case 'portugalPortuguese':
        return SupportedLanguages.portugalPortuguese;
      case 'russian':
        return SupportedLanguages.russian;
      case 'ukrainian':
        return SupportedLanguages.ukrainian;
      case 'polish':
        return SupportedLanguages.polish;
      case 'indonesian':
        return SupportedLanguages.indonesian;
      case 'malay':
        return SupportedLanguages.malay;
      case 'german':
        return SupportedLanguages.german;
      case 'dutch':
        return SupportedLanguages.dutch;
      case 'japanese':
        return SupportedLanguages.japanese;
      case 'swahili':
        return SupportedLanguages.swahili;
      case 'turkish':
        return SupportedLanguages.turkish;
      case 'vietnamese':
        return SupportedLanguages.vietnamese;
      case 'korean':
        return SupportedLanguages.korean;
      case 'italian':
        return SupportedLanguages.italian;
      case 'filipino':
        return SupportedLanguages.filipino;
      case 'romanian':
        return SupportedLanguages.romanian;
      case 'swedish':
        return SupportedLanguages.swedish;
      case 'czech':
        return SupportedLanguages.czech;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SupportedLanguages"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

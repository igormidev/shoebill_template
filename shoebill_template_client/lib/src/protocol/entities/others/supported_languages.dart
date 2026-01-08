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
  mandarinChinese,
  hindi,
  spanish,
  french,
  modernStandardArabic,
  bengali,
  brazilianPortuguese,
  russian,
  urdu,
  indonesian,
  german,
  dutch,
  japanese,
  swahili,
  marathi,
  telugu,
  turkish,
  tamil,
  vietnamese,
  korean,
  italian,
  thai,
  filipino;

  static SupportedLanguages fromJson(String name) {
    switch (name) {
      case 'english':
        return SupportedLanguages.english;
      case 'mandarinChinese':
        return SupportedLanguages.mandarinChinese;
      case 'hindi':
        return SupportedLanguages.hindi;
      case 'spanish':
        return SupportedLanguages.spanish;
      case 'french':
        return SupportedLanguages.french;
      case 'modernStandardArabic':
        return SupportedLanguages.modernStandardArabic;
      case 'bengali':
        return SupportedLanguages.bengali;
      case 'brazilianPortuguese':
        return SupportedLanguages.brazilianPortuguese;
      case 'russian':
        return SupportedLanguages.russian;
      case 'urdu':
        return SupportedLanguages.urdu;
      case 'indonesian':
        return SupportedLanguages.indonesian;
      case 'german':
        return SupportedLanguages.german;
      case 'dutch':
        return SupportedLanguages.dutch;
      case 'japanese':
        return SupportedLanguages.japanese;
      case 'swahili':
        return SupportedLanguages.swahili;
      case 'marathi':
        return SupportedLanguages.marathi;
      case 'telugu':
        return SupportedLanguages.telugu;
      case 'turkish':
        return SupportedLanguages.turkish;
      case 'tamil':
        return SupportedLanguages.tamil;
      case 'vietnamese':
        return SupportedLanguages.vietnamese;
      case 'korean':
        return SupportedLanguages.korean;
      case 'italian':
        return SupportedLanguages.italian;
      case 'thai':
        return SupportedLanguages.thai;
      case 'filipino':
        return SupportedLanguages.filipino;
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

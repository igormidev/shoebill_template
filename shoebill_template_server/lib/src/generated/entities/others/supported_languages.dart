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

  static SupportedLanguages fromJson(int index) {
    switch (index) {
      case 0:
        return SupportedLanguages.english;
      case 1:
        return SupportedLanguages.mandarinChinese;
      case 2:
        return SupportedLanguages.hindi;
      case 3:
        return SupportedLanguages.spanish;
      case 4:
        return SupportedLanguages.french;
      case 5:
        return SupportedLanguages.modernStandardArabic;
      case 6:
        return SupportedLanguages.bengali;
      case 7:
        return SupportedLanguages.brazilianPortuguese;
      case 8:
        return SupportedLanguages.russian;
      case 9:
        return SupportedLanguages.urdu;
      case 10:
        return SupportedLanguages.indonesian;
      case 11:
        return SupportedLanguages.german;
      case 12:
        return SupportedLanguages.japanese;
      case 13:
        return SupportedLanguages.swahili;
      case 14:
        return SupportedLanguages.marathi;
      case 15:
        return SupportedLanguages.telugu;
      case 16:
        return SupportedLanguages.turkish;
      case 17:
        return SupportedLanguages.tamil;
      case 18:
        return SupportedLanguages.vietnamese;
      case 19:
        return SupportedLanguages.korean;
      case 20:
        return SupportedLanguages.italian;
      case 21:
        return SupportedLanguages.thai;
      case 22:
        return SupportedLanguages.filipino;
      default:
        throw ArgumentError(
          'Value "$index" cannot be converted to "SupportedLanguages"',
        );
    }
  }

  @override
  int toJson() => index;

  @override
  String toString() => name;
}

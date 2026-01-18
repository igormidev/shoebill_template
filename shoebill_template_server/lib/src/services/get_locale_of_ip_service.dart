import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shoebill_template_server/src/generated/protocol.dart';

abstract class IGetLocaleOfIpService {
  Future<SupportedLanguages> detectLanguageForCurrentUser(String ip);
}

class GetLocaleOfIpService implements IGetLocaleOfIpService {
  /// Detect the user's language based on their IP address.
  ///
  /// Note: ip-api.com free endpoint is **HTTP only** and for **non-commercial** use.
  /// For production SaaS you'll want their pro (HTTPS) or another provider.
  @override
  Future<SupportedLanguages> detectLanguageForCurrentUser(String ip) async {
    // Call ip-api.com JSON endpoint (no API key).
    // We only ask for what we need: status, message, countryCode, regionName.
    final uri = Uri.parse(
      'http://ip-api.com/json/$ip'
      '?fields=status,message,countryCode,regionName',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      // Fallback if ip-api is down or rate-limited.
      return _getDefaultLanguage();
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['status'] != 'success') {
      // e.g. "private range", "reserved range", "invalid query"
      return _getDefaultLanguage();
    }

    final countryCode = (data['countryCode'] as String?)?.toUpperCase();
    final regionName = data['regionName'] as String?;

    return _mapCountryToSupportedLanguage(
      countryCode: countryCode,
      regionName: regionName,
    );
  }

  /// Heuristic mapping from country / region to your SupportedLanguages enum.
  ///
  /// Values must match your supported_languages.spy.yaml:
  ///   english, mandarinChinese, hindi, spanish, french, modernStandardArabic,
  ///   bengali, brazilianPortuguese, russian, urdu, indonesian, german, japanese,
  ///   swahili, marathi, telugu, turkish, tamil, vietnamese, korean, italian,
  ///   thai, filipino
  SupportedLanguages _mapCountryToSupportedLanguage({
    required String? countryCode,
    required String? regionName,
  }) {
    if (countryCode == null) return SupportedLanguages.english;

    final code = countryCode.toUpperCase();
    final region = regionName?.toLowerCase() ?? '';

    // ----- India: try to distinguish some regional languages -----
    if (code == 'IN') {
      if (region.contains('maharashtra')) {
        return SupportedLanguages.marathi;
      }
      if (region.contains('andhra pradesh') || region.contains('telangana')) {
        return SupportedLanguages.telugu;
      }
      if (region.contains('tamil nadu')) {
        return SupportedLanguages.tamil;
      }
      // Default for India: treat as Hindi.
      return SupportedLanguages.hindi;
    }

    // ----- Country groups for specific languages -----
    const arabicCountries = {
      'SA',
      'AE',
      'QA',
      'OM',
      'KW',
      'BH',
      'EG',
      'DZ',
      'MA',
      'TN',
      'LY',
      'JO',
      'LB',
      'SY',
      'IQ',
      'YE',
      'SD',
      'PS',
    };

    const spanishCountries = {
      'ES',
      'MX',
      'AR',
      'CO',
      'CL',
      'PE',
      'VE',
      'EC',
      'UY',
      'PY',
      'BO',
      'CR',
      'DO',
      'GT',
      'HN',
      'NI',
      'PA',
      'SV',
      'CU',
      'PR',
    };

    const frenchCountries = {'FR', 'BE', 'CH', 'CA', 'SN', 'ML', 'CI', 'CM'};

    const portugueseCountries = {'BR', 'PT', 'AO', 'MZ'};

    const russianCountries = {'RU', 'BY', 'KZ', 'KG'};

    const germanCountries = {'DE', 'AT', 'CH', 'LI', 'LU'};

    const swahiliCountries = {'KE', 'TZ', 'UG', 'RW', 'BI', 'CD', 'SO', 'MZ'};

    const englishCountries = {'US', 'GB', 'IE', 'CA', 'AU', 'NZ', 'ZA'};

    // ----- Single-country mappings -----
    if (code == 'BD') return SupportedLanguages.bengali; // Bangladesh
    if (code == 'PK') return SupportedLanguages.urdu; // Pakistan
    if (code == 'ID') return SupportedLanguages.indonesian; // Indonesia
    if (code == 'VN') return SupportedLanguages.vietnamese; // Vietnam
    if (code == 'KR') return SupportedLanguages.korean; // South Korea
    if (code == 'JP') return SupportedLanguages.japanese; // Japan
    if (code == 'IT') return SupportedLanguages.italian; // Italy
    if (code == 'TR') return SupportedLanguages.turkish; // Turkey
    if (code == 'TH') return SupportedLanguages.thai; // Thailand
    if (code == 'PH') return SupportedLanguages.filipino; // Philippines

    // Mandarin Chinese (simplified heuristic).
    if (code == 'CN' || code == 'TW' || code == 'SG') {
      return SupportedLanguages.mandarinChinese;
    }

    // Modern Standard Arabic.
    if (arabicCountries.contains(code)) {
      return SupportedLanguages.modernStandardArabic;
    }

    if (spanishCountries.contains(code)) {
      return SupportedLanguages.spanish;
    }

    if (frenchCountries.contains(code)) {
      return SupportedLanguages.french;
    }

    // Treat all Lusophone countries as brazilianPortuguese in this enum.
    if (portugueseCountries.contains(code)) {
      return SupportedLanguages.brazilianPortuguese;
    }

    if (russianCountries.contains(code)) {
      return SupportedLanguages.russian;
    }

    if (germanCountries.contains(code)) {
      return SupportedLanguages.german;
    }

    if (swahiliCountries.contains(code)) {
      return SupportedLanguages.swahili;
    }

    if (englishCountries.contains(code)) {
      return SupportedLanguages.english;
    }

    // Final fallback
    return _getDefaultLanguage();
  }

  SupportedLanguages _getDefaultLanguage() {
    return SupportedLanguages.english;
  }
}

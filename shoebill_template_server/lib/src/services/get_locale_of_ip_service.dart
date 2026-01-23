import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:shoebill_template_server/src/core/utils/consts.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

/// Default language returned when geolocation fails or the country is unknown.
const SupportedLanguages _kDefaultLanguage = SupportedLanguages.english;

/// Timeout for HTTP requests to the IP geolocation API.
const Duration _kGeolocationRequestTimeout = Duration(seconds: 5);

/// Fields requested from the ip-api.com endpoint.
const String _kGeolocationApiFields = 'status,message,countryCode,regionName';

abstract class IGetLocaleOfIpService {
  Future<SupportedLanguages> detectLanguageForCurrentUser(String ip);
}

class GetLocaleOfIpService implements IGetLocaleOfIpService {
  GetLocaleOfIpService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// Detect the user's language based on their IP address.
  ///
  /// Note: ip-api.com free endpoint is **HTTP only** and for **non-commercial** use.
  /// For production SaaS you'll want their pro (HTTPS) or another provider.
  ///
  /// Returns [_kDefaultLanguage] if the geolocation request fails for any
  /// reason (network error, timeout, invalid response, etc.).
  @override
  Future<SupportedLanguages> detectLanguageForCurrentUser(String ip) async {
    final uri = Uri.parse(
      '$kIpGeolocationApiBaseUrl$ip'
      '?fields=$_kGeolocationApiFields',
    );

    final http.Response response;
    try {
      response = await _httpClient.get(uri).timeout(_kGeolocationRequestTimeout);
    } on Exception catch (e) {
      developer.log(
        'IP geolocation request failed for IP "$ip": $e',
        name: 'GetLocaleOfIpService',
        level: 900, // WARNING
      );
      return _kDefaultLanguage;
    }

    if (response.statusCode != 200) {
      developer.log(
        'IP geolocation returned HTTP ${response.statusCode} for IP "$ip"',
        name: 'GetLocaleOfIpService',
        level: 900,
      );
      return _kDefaultLanguage;
    }

    final Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException catch (e) {
      developer.log(
        'Failed to parse geolocation response for IP "$ip": $e',
        name: 'GetLocaleOfIpService',
        level: 900,
      );
      return _kDefaultLanguage;
    }

    if (data['status'] != 'success') {
      developer.log(
        'IP geolocation lookup failed for IP "$ip": ${data['message'] ?? 'unknown reason'}',
        name: 'GetLocaleOfIpService',
        level: 800, // INFO
      );
      return _kDefaultLanguage;
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
  ///   english, simplifiedMandarinChinese, traditionalChinese, spanish, french,
  ///   brazilianPortuguese, portugalPortuguese, russian, ukrainian, polish,
  ///   indonesian, malay, german, dutch, japanese, swahili, turkish, vietnamese,
  ///   korean, italian, filipino, romanian, swedish, czech
  SupportedLanguages _mapCountryToSupportedLanguage({
    required String? countryCode,
    required String? regionName,
  }) {
    if (countryCode == null) return _kDefaultLanguage;

    final code = countryCode.toUpperCase();

    // ----- Country groups for specific languages -----
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

    const frenchCountries = {'FR', 'BE', 'SN', 'ML', 'CI', 'CM'};

    const russianCountries = {'RU', 'BY', 'KZ', 'KG'};

    const germanCountries = {'DE', 'AT', 'LI', 'LU'};

    const swahiliCountries = {'KE', 'TZ', 'UG', 'RW', 'BI', 'CD', 'SO'};

    const englishCountries = {'US', 'GB', 'IE', 'CA', 'AU', 'NZ', 'ZA'};

    // ----- Single-country mappings -----
    if (code == 'ID') return SupportedLanguages.indonesian; // Indonesia
    if (code == 'MY') return SupportedLanguages.malay; // Malaysia
    if (code == 'VN') return SupportedLanguages.vietnamese; // Vietnam
    if (code == 'KR') return SupportedLanguages.korean; // South Korea
    if (code == 'JP') return SupportedLanguages.japanese; // Japan
    if (code == 'IT') return SupportedLanguages.italian; // Italy
    if (code == 'TR') return SupportedLanguages.turkish; // Turkey
    if (code == 'PH') return SupportedLanguages.filipino; // Philippines
    if (code == 'UA') return SupportedLanguages.ukrainian; // Ukraine
    if (code == 'PL') return SupportedLanguages.polish; // Poland
    if (code == 'RO') return SupportedLanguages.romanian; // Romania
    if (code == 'SE') return SupportedLanguages.swedish; // Sweden
    if (code == 'CZ') return SupportedLanguages.czech; // Czech Republic
    if (code == 'NL') return SupportedLanguages.dutch; // Netherlands
    if (code == 'BR') return SupportedLanguages.brazilianPortuguese; // Brazil
    if (code == 'PT') return SupportedLanguages.portugalPortuguese; // Portugal

    // Simplified Mandarin Chinese (mainland China, Singapore).
    if (code == 'CN' || code == 'SG') {
      return SupportedLanguages.simplifiedMandarinChinese;
    }

    // Traditional Chinese (Taiwan, Hong Kong).
    if (code == 'TW' || code == 'HK') {
      return SupportedLanguages.traditionalChinese;
    }

    if (spanishCountries.contains(code)) {
      return SupportedLanguages.spanish;
    }

    if (frenchCountries.contains(code)) {
      return SupportedLanguages.french;
    }

    if (russianCountries.contains(code)) {
      return SupportedLanguages.russian;
    }

    if (germanCountries.contains(code)) {
      return SupportedLanguages.german;
    }

    // German-speaking part of Switzerland defaults to German.
    if (code == 'CH') return SupportedLanguages.german;

    if (swahiliCountries.contains(code)) {
      return SupportedLanguages.swahili;
    }

    if (englishCountries.contains(code)) {
      return SupportedLanguages.english;
    }

    // Final fallback
    return _kDefaultLanguage;
  }
}

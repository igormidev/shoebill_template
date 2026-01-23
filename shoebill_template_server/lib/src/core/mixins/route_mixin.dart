import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/generated/entities/others/supported_languages.dart';

mixin RouteMixin on Route {
  static const kLanguageParam = 'language';
  static const kUuidParam = 'uuid';

  SupportedLanguages? getLanguageCode(Request request) {
    final queryParameters = request.queryParameters.raw;
    final code = queryParameters[kLanguageParam];
    return SupportedLanguages.values.firstWhereOrNull(
      (lang) => lang.name == code,
    );
  }

  (String?, Response?) validateUuid(Request request) {
    final queryParameters = request.queryParameters.raw;
    final String? uuid = queryParameters[kUuidParam];
    final isValidUuid = uuid != null && Uuid.isValidUUID(fromString: uuid);
    if (!isValidUuid) {
      return (
        null,
        createErrorResponse(
          400,
          'Bad Request',
          uuid == null
              ? 'Missing UUID in query parameters (should be uuid v4 or v7). Pass the uuid as "?uuid=" in query param field'
              : 'Invalid UUID in query parameters (should be uuid v4 or v7)',
        ),
      );
    }

    return (uuid, null);
  }

  Future<(Map<String, dynamic>?, Response?)> getPayload(Request request) async {
    // Read and parse the request body
    final body = await request.readAsString();
    if (body.isEmpty) {
      return (
        null,
        createErrorResponse(400, 'Bad Request', 'Request body is required'),
      );
    }

    try {
      return (jsonDecode(body) as Map<String, dynamic>, null);
    } catch (e) {
      return (
        null,
        createErrorResponse(400, 'Bad Request', 'Invalid JSON in request body'),
      );
    }
  }

  Response createErrorResponse(
    int statusCode,
    String title,
    String description,
  ) {
    final errorResponse = {
      'error': {
        'title': title,
        'description': description,
        'statusCode': statusCode,
      },
    };

    return Response(
      statusCode,
      body: Body.fromString(jsonEncode(errorResponse), mimeType: MimeType.json),
    );
  }
}

/// Safely decode JSON into a Map.
/// Returns null if the JSON is invalid or not a JSON object.
Map<String, dynamic>? tryDecode(String source) {
  try {
    final decoded = jsonDecode(source);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null; // JSON exists but isn't a Map (e.g. it's a List/int/string)
  } catch (_) {
    return null; // Invalid JSON or decode error
  }
}

/// Produces a SHA-256 hash of the given [input] string.
///
/// Used for generating session identifiers by hashing language + IP combinations.
/// SHA-256 is used instead of SHA-1 because the resulting hash is exposed as a
/// URL query parameter (`sI`) and serves as a session token. SHA-1's known
/// collision vulnerabilities could allow an attacker to forge session IDs,
/// potentially manipulating which language variant of a PDF is served.
String hashString(String input) {
  final digest = sha256.convert(utf8.encode(input));
  return digest.toString();
}

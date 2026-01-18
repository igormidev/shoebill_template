import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/generated/entities/others/supported_languages.dart';

mixin RouteMixin on Route {
  SupportedLanguages? getLanguageCode(Request request) {
    final queryParameters = request.queryParameters.raw;
    final code = queryParameters['language'];
    return SupportedLanguages.values.firstWhereOrNull(
      (lang) => lang.name == code,
    );
  }

  (String uuid, Response? error) validateUuid(Request request) {
    final queryParameters = request.queryParameters.raw;
    final String? uuid = queryParameters['uuid'];
    final isValidUuid = uuid != null && Uuid.isValidUUID(fromString: uuid);
    if (!isValidUuid) {
      return (
        '',
        Response.badRequest(
          body: Body.fromString(
            uuid == null
                ? 'Missing UUID in query parameters (should be uuid v4 or v7). Pass the uuid as "?uuid=" in query param field'
                : 'Invalid UUID in query parameters (should be uuid v4 or v7)',
          ),
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

String sha1OfString(String input) {
  final digest = sha1.convert(utf8.encode(input));
  return digest.toString();
}

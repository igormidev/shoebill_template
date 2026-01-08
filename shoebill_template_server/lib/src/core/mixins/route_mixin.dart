import 'dart:convert';

import 'package:serverpod/serverpod.dart';

mixin RouteMixin on Route {
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

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/server.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/get_locale_of_ip_service.dart';
import 'package:shoebill_template_server/src/services/pdf_controller.dart';

class PdfVisualizeRoute extends Route with RouteMixin {
  final PdfController pdfController = getIt<PdfController>();
  final IGetLocaleOfIpService getLocaleOfIpService =
      getIt<IGetLocaleOfIpService>();
  PdfVisualizeRoute() : super(methods: {Method.get});

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    final (uuid, uuidError) = validateUuid(request);
    if (uuidError != null) return uuidError;

    final PdfDeclaration? pdfDeclaration = await PdfDeclaration.db.findById(
      session,
      UuidValue.fromString(uuid),
    );
    if (pdfDeclaration == null) {
      return Response.notFound(
        body: Body.fromString(
          'No PDF Declaration found for the provided ID: $uuid',
        ),
      );
    }

    SupportedLanguages selectedLanguage;
    final userIp = request.remoteInfo;
    final queryParameters = request.queryParameters.raw;
    final sessionId = queryParameters['sI'];
    if (sessionId == null) {
      final ipLanguage = await getLocaleOfIpService
          .detectLanguageForCurrentUser(userIp);

      selectedLanguage = ipLanguage;
    } else {
      // Lets get the language of session id
      final SupportedLanguages? sessionLanguage = SupportedLanguages.values
          .firstWhereOrNull((t) => sha1OfString(t.name + userIp) == sessionId);

      // If does not exist, it means the client probably got this link for another source (someone, with a other ip, send it to him)
      // So we don't want to keep configs (like selected language) from other users, so we fallback to ip detection
      if (sessionLanguage == null) {
        final ipLanguage = await getLocaleOfIpService
            .detectLanguageForCurrentUser(userIp);

        selectedLanguage = ipLanguage;
      } else {
        selectedLanguage = sessionLanguage;
      }
    }

    /*
      The rule for language is:
        - If the language code IS provided, use it if the user ip localization matches OR it is english
        - If the language code IS NOT provided, use it if the user ip localization if that language is supported OR it is english
        - If no language code is provided and no match, use default language of the PDF Declaration
    */
    PdfImplementationPayload? pdfImplementation = await PdfImplementationPayload
        .db
        .findFirstRow(
          session,
          where: (pI) =>
              pI.pdfDeclarationId.equals(pdfDeclaration.id) &
              pI.language.equals(selectedLanguage),
        );

    final bool stillDidNotCreateLanguage = pdfImplementation == null;
    if (stillDidNotCreateLanguage) {
      // Let's create
      pdfImplementation = await pdfController.addNewLanguageToExistingPdf(
        session: session,
        pdfDeclarationId: pdfDeclaration.id,
        targetLanguage: selectedLanguage,
      );
    }

    final pdfBytes = await pdfController.getPdfFromScript(
      session: session,
      script: pdfDeclaration.pythonGeneratorScript,
      stringifiedPayload: pdfImplementation.stringifiedJson,
      language: pdfImplementation.language,
    );

    return Response.ok(
      body: Body.fromData(
        pdfBytes,
        mimeType: MimeType.pdf,
      ),
    );
  }
}

import 'package:shoebill_template_server/src/api/chat_session_related/remote_ai_coding_session.dart';

class IChatController {
  final IRemoteAiCodingSession coddingSession;
  const IChatController({
    required this.coddingSession,
  });
}

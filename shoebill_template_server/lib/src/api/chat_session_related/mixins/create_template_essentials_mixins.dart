import 'dart:convert';

import 'package:shoebill_template_server/server.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/ai_services.dart';

mixin CreateTemplateEssentialsMixins {
  // Will return one of two
  Stream<({
      TemplateEssential? template,
      AiThinkingChunk? aiThinkingChunk,
  })>
  createTemplateEssentials({
    required String stringifiedPayload,
  })  {
    final Map<String, dynamic>? payload = tryDecode(stringifiedPayload);
    if(payload==null){
      throw ShoebillException(
        title: '',
        description: '',
      );
    }

    final prettyVersionOfJsonForPrompt = JsonEncoder.withIndent('  ').convert(payload);

    final aiServices = getIt<IOpenAiService>();
    return aiServices.streamPromptGenerationWithSchemaResponse(
      prompt: '''''',
      properties: {
        'pdfContent': ,
        'schemaDefinition': ,
        'suggestedPrompt': ,
        'referenceLanguage': ,
      },
    ).transform();
  }
}

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
import 'api/chat_session_related/entities/messages/chat_actor.dart' as _i2;
import 'api/chat_session_related/entities/messages/chat_message.dart' as _i3;
import 'api/chat_session_related/entities/messages/chat_ui_style.dart' as _i4;
import 'api/chat_session_related/entities/template_essential.dart' as _i5;
import 'api/pdf_related/entities/pdf_content.dart' as _i6;
import 'api/pdf_related/entities/pdf_declaration.dart' as _i7;
import 'api/pdf_related/entities/pdf_implementation_payload.dart' as _i8;
import 'api/pdf_related/entities/schema_definition.dart' as _i9;
import 'api/pdf_related/entities/schemas_implementations/schema_property.dart'
    as _i10;
import 'entities/others/ai_thinking_chunk.dart' as _i11;
import 'entities/others/shoebill_exception.dart' as _i12;
import 'entities/others/supported_languages.dart' as _i13;
import 'entities/template/shoebill_template.dart' as _i14;
import 'greetings/greeting.dart' as _i15;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i16;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i17;
export 'api/chat_session_related/entities/messages/chat_actor.dart';
export 'api/chat_session_related/entities/messages/chat_message.dart';
export 'api/chat_session_related/entities/messages/chat_ui_style.dart';
export 'api/chat_session_related/entities/template_essential.dart';
export 'api/pdf_related/entities/pdf_content.dart';
export 'api/pdf_related/entities/pdf_declaration.dart';
export 'api/pdf_related/entities/pdf_implementation_payload.dart';
export 'api/pdf_related/entities/schema_definition.dart';
export 'api/pdf_related/entities/schemas_implementations/schema_property.dart';
export 'entities/others/ai_thinking_chunk.dart';
export 'entities/others/shoebill_exception.dart';
export 'entities/others/supported_languages.dart';
export 'entities/template/shoebill_template.dart';
export 'greetings/greeting.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.ChatActor) {
      return _i2.ChatActor.fromJson(data) as T;
    }
    if (t == _i3.ChatMessage) {
      return _i3.ChatMessage.fromJson(data) as T;
    }
    if (t == _i4.ChatUIStyle) {
      return _i4.ChatUIStyle.fromJson(data) as T;
    }
    if (t == _i5.TemplateEssential) {
      return _i5.TemplateEssential.fromJson(data) as T;
    }
    if (t == _i6.PdfContent) {
      return _i6.PdfContent.fromJson(data) as T;
    }
    if (t == _i7.PdfDeclaration) {
      return _i7.PdfDeclaration.fromJson(data) as T;
    }
    if (t == _i8.PdfImplementationPayload) {
      return _i8.PdfImplementationPayload.fromJson(data) as T;
    }
    if (t == _i9.SchemaDefinition) {
      return _i9.SchemaDefinition.fromJson(data) as T;
    }
    if (t == _i10.SchemaPropertyArray) {
      return _i10.SchemaPropertyArray.fromJson(data) as T;
    }
    if (t == _i10.SchemaPropertyBoolean) {
      return _i10.SchemaPropertyBoolean.fromJson(data) as T;
    }
    if (t == _i10.SchemaPropertyDouble) {
      return _i10.SchemaPropertyDouble.fromJson(data) as T;
    }
    if (t == _i10.SchemaPropertyEnum) {
      return _i10.SchemaPropertyEnum.fromJson(data) as T;
    }
    if (t == _i10.SchemaPropertyInteger) {
      return _i10.SchemaPropertyInteger.fromJson(data) as T;
    }
    if (t == _i10.SchemaPropertyObjectWithUndefinedProperties) {
      return _i10.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
          as T;
    }
    if (t == _i10.SchemaPropertyString) {
      return _i10.SchemaPropertyString.fromJson(data) as T;
    }
    if (t == _i10.SchemaPropertyStructuredObjectWithDefinedProperties) {
      return _i10.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
            data,
          )
          as T;
    }
    if (t == _i11.AiThinkingChunk) {
      return _i11.AiThinkingChunk.fromJson(data) as T;
    }
    if (t == _i12.ShoebillException) {
      return _i12.ShoebillException.fromJson(data) as T;
    }
    if (t == _i13.SupportedLanguages) {
      return _i13.SupportedLanguages.fromJson(data) as T;
    }
    if (t == _i14.TemplatePdf) {
      return _i14.TemplatePdf.fromJson(data) as T;
    }
    if (t == _i15.Greeting) {
      return _i15.Greeting.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ChatActor?>()) {
      return (data != null ? _i2.ChatActor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ChatMessage?>()) {
      return (data != null ? _i3.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.ChatUIStyle?>()) {
      return (data != null ? _i4.ChatUIStyle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.TemplateEssential?>()) {
      return (data != null ? _i5.TemplateEssential.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.PdfContent?>()) {
      return (data != null ? _i6.PdfContent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PdfDeclaration?>()) {
      return (data != null ? _i7.PdfDeclaration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PdfImplementationPayload?>()) {
      return (data != null ? _i8.PdfImplementationPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.SchemaDefinition?>()) {
      return (data != null ? _i9.SchemaDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.SchemaPropertyArray?>()) {
      return (data != null ? _i10.SchemaPropertyArray.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.SchemaPropertyBoolean?>()) {
      return (data != null ? _i10.SchemaPropertyBoolean.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.SchemaPropertyDouble?>()) {
      return (data != null ? _i10.SchemaPropertyDouble.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.SchemaPropertyEnum?>()) {
      return (data != null ? _i10.SchemaPropertyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.SchemaPropertyInteger?>()) {
      return (data != null ? _i10.SchemaPropertyInteger.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.SchemaPropertyObjectWithUndefinedProperties?>()) {
      return (data != null
              ? _i10.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i10.SchemaPropertyString?>()) {
      return (data != null ? _i10.SchemaPropertyString.fromJson(data) : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              _i10.SchemaPropertyStructuredObjectWithDefinedProperties?
            >()) {
      return (data != null
              ? _i10.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.AiThinkingChunk?>()) {
      return (data != null ? _i11.AiThinkingChunk.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ShoebillException?>()) {
      return (data != null ? _i12.ShoebillException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.SupportedLanguages?>()) {
      return (data != null ? _i13.SupportedLanguages.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.TemplatePdf?>()) {
      return (data != null ? _i14.TemplatePdf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Greeting?>()) {
      return (data != null ? _i15.Greeting.fromJson(data) : null) as T;
    }
    if (t == List<_i8.PdfImplementationPayload>) {
      return (data as List)
              .map((e) => deserialize<_i8.PdfImplementationPayload>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i8.PdfImplementationPayload>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8.PdfImplementationPayload>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, _i10.SchemaProperty>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i10.SchemaProperty>(v),
            ),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i16.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i17.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ChatActor => 'ChatActor',
      _i3.ChatMessage => 'ChatMessage',
      _i4.ChatUIStyle => 'ChatUIStyle',
      _i5.TemplateEssential => 'TemplateEssential',
      _i6.PdfContent => 'PdfContent',
      _i7.PdfDeclaration => 'PdfDeclaration',
      _i8.PdfImplementationPayload => 'PdfImplementationPayload',
      _i9.SchemaDefinition => 'SchemaDefinition',
      _i10.SchemaPropertyArray => 'SchemaPropertyArray',
      _i10.SchemaPropertyBoolean => 'SchemaPropertyBoolean',
      _i10.SchemaPropertyDouble => 'SchemaPropertyDouble',
      _i10.SchemaPropertyEnum => 'SchemaPropertyEnum',
      _i10.SchemaPropertyInteger => 'SchemaPropertyInteger',
      _i10.SchemaPropertyObjectWithUndefinedProperties =>
        'SchemaPropertyObjectWithUndefinedProperties',
      _i10.SchemaPropertyString => 'SchemaPropertyString',
      _i10.SchemaPropertyStructuredObjectWithDefinedProperties =>
        'SchemaPropertyStructuredObjectWithDefinedProperties',
      _i11.AiThinkingChunk => 'AiThinkingChunk',
      _i12.ShoebillException => 'ShoebillException',
      _i13.SupportedLanguages => 'SupportedLanguages',
      _i14.TemplatePdf => 'TemplatePdf',
      _i15.Greeting => 'Greeting',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'shoebill_template.',
        '',
      );
    }

    switch (data) {
      case _i2.ChatActor():
        return 'ChatActor';
      case _i3.ChatMessage():
        return 'ChatMessage';
      case _i4.ChatUIStyle():
        return 'ChatUIStyle';
      case _i5.TemplateEssential():
        return 'TemplateEssential';
      case _i6.PdfContent():
        return 'PdfContent';
      case _i7.PdfDeclaration():
        return 'PdfDeclaration';
      case _i8.PdfImplementationPayload():
        return 'PdfImplementationPayload';
      case _i9.SchemaDefinition():
        return 'SchemaDefinition';
      case _i10.SchemaPropertyArray():
        return 'SchemaPropertyArray';
      case _i10.SchemaPropertyBoolean():
        return 'SchemaPropertyBoolean';
      case _i10.SchemaPropertyDouble():
        return 'SchemaPropertyDouble';
      case _i10.SchemaPropertyEnum():
        return 'SchemaPropertyEnum';
      case _i10.SchemaPropertyInteger():
        return 'SchemaPropertyInteger';
      case _i10.SchemaPropertyObjectWithUndefinedProperties():
        return 'SchemaPropertyObjectWithUndefinedProperties';
      case _i10.SchemaPropertyString():
        return 'SchemaPropertyString';
      case _i10.SchemaPropertyStructuredObjectWithDefinedProperties():
        return 'SchemaPropertyStructuredObjectWithDefinedProperties';
      case _i11.AiThinkingChunk():
        return 'AiThinkingChunk';
      case _i12.ShoebillException():
        return 'ShoebillException';
      case _i13.SupportedLanguages():
        return 'SupportedLanguages';
      case _i14.TemplatePdf():
        return 'TemplatePdf';
      case _i15.Greeting():
        return 'Greeting';
    }
    className = _i16.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i17.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ChatActor') {
      return deserialize<_i2.ChatActor>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i3.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatUIStyle') {
      return deserialize<_i4.ChatUIStyle>(data['data']);
    }
    if (dataClassName == 'TemplateEssential') {
      return deserialize<_i5.TemplateEssential>(data['data']);
    }
    if (dataClassName == 'PdfContent') {
      return deserialize<_i6.PdfContent>(data['data']);
    }
    if (dataClassName == 'PdfDeclaration') {
      return deserialize<_i7.PdfDeclaration>(data['data']);
    }
    if (dataClassName == 'PdfImplementationPayload') {
      return deserialize<_i8.PdfImplementationPayload>(data['data']);
    }
    if (dataClassName == 'SchemaDefinition') {
      return deserialize<_i9.SchemaDefinition>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyArray') {
      return deserialize<_i10.SchemaPropertyArray>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyBoolean') {
      return deserialize<_i10.SchemaPropertyBoolean>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyDouble') {
      return deserialize<_i10.SchemaPropertyDouble>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyEnum') {
      return deserialize<_i10.SchemaPropertyEnum>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyInteger') {
      return deserialize<_i10.SchemaPropertyInteger>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyObjectWithUndefinedProperties') {
      return deserialize<_i10.SchemaPropertyObjectWithUndefinedProperties>(
        data['data'],
      );
    }
    if (dataClassName == 'SchemaPropertyString') {
      return deserialize<_i10.SchemaPropertyString>(data['data']);
    }
    if (dataClassName ==
        'SchemaPropertyStructuredObjectWithDefinedProperties') {
      return deserialize<
        _i10.SchemaPropertyStructuredObjectWithDefinedProperties
      >(data['data']);
    }
    if (dataClassName == 'AiThinkingChunk') {
      return deserialize<_i11.AiThinkingChunk>(data['data']);
    }
    if (dataClassName == 'ShoebillException') {
      return deserialize<_i12.ShoebillException>(data['data']);
    }
    if (dataClassName == 'SupportedLanguages') {
      return deserialize<_i13.SupportedLanguages>(data['data']);
    }
    if (dataClassName == 'TemplatePdf') {
      return deserialize<_i14.TemplatePdf>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i15.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i16.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i17.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

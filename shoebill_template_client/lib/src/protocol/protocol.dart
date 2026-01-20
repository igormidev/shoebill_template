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
import 'api/chat_session_related/entities/template_current_state/template_current_state.dart'
    as _i5;
import 'api/chat_session_related/entities/template_essential.dart' as _i6;
import 'api/pdf_related/entities/pdf_content.dart' as _i7;
import 'api/pdf_related/entities/pdf_declaration.dart' as _i8;
import 'api/pdf_related/entities/pdf_implementation_payload.dart' as _i9;
import 'api/pdf_related/entities/schema_definition.dart' as _i10;
import 'api/pdf_related/entities/schemas_implementations/schema_property.dart'
    as _i11;
import 'api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i12;
import 'api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i13;
import 'api/pdf_related/entities/template_entities/shoebill_template_version_implementation.dart'
    as _i14;
import 'api/pdf_related/entities/template_entities/shoebill_template_version_input.dart'
    as _i15;
import 'entities/others/ai_thinking_chunk.dart' as _i16;
import 'entities/others/shoebill_exception.dart' as _i17;
import 'entities/others/supported_languages.dart' as _i18;
import 'entities/template/shoebill_template.dart' as _i19;
import 'greetings/greeting.dart' as _i20;
import 'package:shoebill_template_client/src/protocol/entities/others/ai_thinking_chunk.dart'
    as _i21;
import 'package:shoebill_template_client/src/protocol/api/chat_session_related/entities/template_essential.dart'
    as _i22;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i23;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i24;
export 'api/chat_session_related/entities/messages/chat_actor.dart';
export 'api/chat_session_related/entities/messages/chat_message.dart';
export 'api/chat_session_related/entities/messages/chat_ui_style.dart';
export 'api/chat_session_related/entities/template_current_state/template_current_state.dart';
export 'api/chat_session_related/entities/template_essential.dart';
export 'api/pdf_related/entities/pdf_content.dart';
export 'api/pdf_related/entities/pdf_declaration.dart';
export 'api/pdf_related/entities/pdf_implementation_payload.dart';
export 'api/pdf_related/entities/schema_definition.dart';
export 'api/pdf_related/entities/schemas_implementations/schema_property.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_version.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_version_implementation.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_version_input.dart';
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
    if (t == _i5.DeployReadyTemplateState) {
      return _i5.DeployReadyTemplateState.fromJson(data) as T;
    }
    if (t == _i5.NewTemplateState) {
      return _i5.NewTemplateState.fromJson(data) as T;
    }
    if (t == _i6.TemplateEssential) {
      return _i6.TemplateEssential.fromJson(data) as T;
    }
    if (t == _i7.PdfContent) {
      return _i7.PdfContent.fromJson(data) as T;
    }
    if (t == _i8.PdfDeclaration) {
      return _i8.PdfDeclaration.fromJson(data) as T;
    }
    if (t == _i9.PdfImplementationPayload) {
      return _i9.PdfImplementationPayload.fromJson(data) as T;
    }
    if (t == _i10.SchemaDefinition) {
      return _i10.SchemaDefinition.fromJson(data) as T;
    }
    if (t == _i11.SchemaPropertyArray) {
      return _i11.SchemaPropertyArray.fromJson(data) as T;
    }
    if (t == _i11.SchemaPropertyBoolean) {
      return _i11.SchemaPropertyBoolean.fromJson(data) as T;
    }
    if (t == _i11.SchemaPropertyDouble) {
      return _i11.SchemaPropertyDouble.fromJson(data) as T;
    }
    if (t == _i11.SchemaPropertyEnum) {
      return _i11.SchemaPropertyEnum.fromJson(data) as T;
    }
    if (t == _i11.SchemaPropertyInteger) {
      return _i11.SchemaPropertyInteger.fromJson(data) as T;
    }
    if (t == _i11.SchemaPropertyObjectWithUndefinedProperties) {
      return _i11.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
          as T;
    }
    if (t == _i11.SchemaPropertyString) {
      return _i11.SchemaPropertyString.fromJson(data) as T;
    }
    if (t == _i11.SchemaPropertyStructuredObjectWithDefinedProperties) {
      return _i11.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
            data,
          )
          as T;
    }
    if (t == _i12.ShoebillTemplateScaffold) {
      return _i12.ShoebillTemplateScaffold.fromJson(data) as T;
    }
    if (t == _i13.ShoebillTemplateVersion) {
      return _i13.ShoebillTemplateVersion.fromJson(data) as T;
    }
    if (t == _i14.ShoebillTemplateVersionImplementation) {
      return _i14.ShoebillTemplateVersionImplementation.fromJson(data) as T;
    }
    if (t == _i15.ShoebillTemplateVersionInput) {
      return _i15.ShoebillTemplateVersionInput.fromJson(data) as T;
    }
    if (t == _i16.AiThinkingChunk) {
      return _i16.AiThinkingChunk.fromJson(data) as T;
    }
    if (t == _i17.ShoebillException) {
      return _i17.ShoebillException.fromJson(data) as T;
    }
    if (t == _i18.SupportedLanguages) {
      return _i18.SupportedLanguages.fromJson(data) as T;
    }
    if (t == _i19.TemplatePdf) {
      return _i19.TemplatePdf.fromJson(data) as T;
    }
    if (t == _i20.Greeting) {
      return _i20.Greeting.fromJson(data) as T;
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
    if (t == _i1.getType<_i5.DeployReadyTemplateState?>()) {
      return (data != null ? _i5.DeployReadyTemplateState.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.NewTemplateState?>()) {
      return (data != null ? _i5.NewTemplateState.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.TemplateEssential?>()) {
      return (data != null ? _i6.TemplateEssential.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PdfContent?>()) {
      return (data != null ? _i7.PdfContent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PdfDeclaration?>()) {
      return (data != null ? _i8.PdfDeclaration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PdfImplementationPayload?>()) {
      return (data != null ? _i9.PdfImplementationPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.SchemaDefinition?>()) {
      return (data != null ? _i10.SchemaDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.SchemaPropertyArray?>()) {
      return (data != null ? _i11.SchemaPropertyArray.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.SchemaPropertyBoolean?>()) {
      return (data != null ? _i11.SchemaPropertyBoolean.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.SchemaPropertyDouble?>()) {
      return (data != null ? _i11.SchemaPropertyDouble.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.SchemaPropertyEnum?>()) {
      return (data != null ? _i11.SchemaPropertyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.SchemaPropertyInteger?>()) {
      return (data != null ? _i11.SchemaPropertyInteger.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.SchemaPropertyObjectWithUndefinedProperties?>()) {
      return (data != null
              ? _i11.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.SchemaPropertyString?>()) {
      return (data != null ? _i11.SchemaPropertyString.fromJson(data) : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              _i11.SchemaPropertyStructuredObjectWithDefinedProperties?
            >()) {
      return (data != null
              ? _i11.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.ShoebillTemplateScaffold?>()) {
      return (data != null
              ? _i12.ShoebillTemplateScaffold.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.ShoebillTemplateVersion?>()) {
      return (data != null ? _i13.ShoebillTemplateVersion.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.ShoebillTemplateVersionImplementation?>()) {
      return (data != null
              ? _i14.ShoebillTemplateVersionImplementation.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.ShoebillTemplateVersionInput?>()) {
      return (data != null
              ? _i15.ShoebillTemplateVersionInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.AiThinkingChunk?>()) {
      return (data != null ? _i16.AiThinkingChunk.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ShoebillException?>()) {
      return (data != null ? _i17.ShoebillException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.SupportedLanguages?>()) {
      return (data != null ? _i18.SupportedLanguages.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.TemplatePdf?>()) {
      return (data != null ? _i19.TemplatePdf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Greeting?>()) {
      return (data != null ? _i20.Greeting.fromJson(data) : null) as T;
    }
    if (t == List<_i9.PdfImplementationPayload>) {
      return (data as List)
              .map((e) => deserialize<_i9.PdfImplementationPayload>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.PdfImplementationPayload>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i9.PdfImplementationPayload>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, _i11.SchemaProperty>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i11.SchemaProperty>(v),
            ),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i13.ShoebillTemplateVersion>) {
      return (data as List)
              .map((e) => deserialize<_i13.ShoebillTemplateVersion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i13.ShoebillTemplateVersion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i13.ShoebillTemplateVersion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i14.ShoebillTemplateVersionImplementation>) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<_i14.ShoebillTemplateVersionImplementation>(e),
              )
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i14.ShoebillTemplateVersionImplementation>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            _i14.ShoebillTemplateVersionImplementation
                          >(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              ({
                _i21.AiThinkingChunk? aiThinkingChunk,
                _i22.TemplateEssential? template,
              })
            >()) {
      return (
            aiThinkingChunk:
                ((data as Map)['n'] as Map)['aiThinkingChunk'] == null
                ? null
                : deserialize<_i21.AiThinkingChunk>(
                    data['n']['aiThinkingChunk'],
                  ),
            template: ((data)['n'] as Map)['template'] == null
                ? null
                : deserialize<_i22.TemplateEssential>(data['n']['template']),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              ({
                _i21.AiThinkingChunk? aiThinkingChunk,
                _i22.TemplateEssential? template,
              })
            >()) {
      return (
            aiThinkingChunk:
                ((data as Map)['n'] as Map)['aiThinkingChunk'] == null
                ? null
                : deserialize<_i21.AiThinkingChunk>(
                    data['n']['aiThinkingChunk'],
                  ),
            template: ((data)['n'] as Map)['template'] == null
                ? null
                : deserialize<_i22.TemplateEssential>(data['n']['template']),
          )
          as T;
    }
    try {
      return _i23.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i24.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ChatActor => 'ChatActor',
      _i3.ChatMessage => 'ChatMessage',
      _i4.ChatUIStyle => 'ChatUIStyle',
      _i5.DeployReadyTemplateState => 'DeployReadyTemplateState',
      _i5.NewTemplateState => 'NewTemplateState',
      _i6.TemplateEssential => 'TemplateEssential',
      _i7.PdfContent => 'PdfContent',
      _i8.PdfDeclaration => 'PdfDeclaration',
      _i9.PdfImplementationPayload => 'PdfImplementationPayload',
      _i10.SchemaDefinition => 'SchemaDefinition',
      _i11.SchemaPropertyArray => 'SchemaPropertyArray',
      _i11.SchemaPropertyBoolean => 'SchemaPropertyBoolean',
      _i11.SchemaPropertyDouble => 'SchemaPropertyDouble',
      _i11.SchemaPropertyEnum => 'SchemaPropertyEnum',
      _i11.SchemaPropertyInteger => 'SchemaPropertyInteger',
      _i11.SchemaPropertyObjectWithUndefinedProperties =>
        'SchemaPropertyObjectWithUndefinedProperties',
      _i11.SchemaPropertyString => 'SchemaPropertyString',
      _i11.SchemaPropertyStructuredObjectWithDefinedProperties =>
        'SchemaPropertyStructuredObjectWithDefinedProperties',
      _i12.ShoebillTemplateScaffold => 'ShoebillTemplateScaffold',
      _i13.ShoebillTemplateVersion => 'ShoebillTemplateVersion',
      _i14.ShoebillTemplateVersionImplementation =>
        'ShoebillTemplateVersionImplementation',
      _i15.ShoebillTemplateVersionInput => 'ShoebillTemplateVersionInput',
      _i16.AiThinkingChunk => 'AiThinkingChunk',
      _i17.ShoebillException => 'ShoebillException',
      _i18.SupportedLanguages => 'SupportedLanguages',
      _i19.TemplatePdf => 'TemplatePdf',
      _i20.Greeting => 'Greeting',
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
      case _i5.DeployReadyTemplateState():
        return 'DeployReadyTemplateState';
      case _i5.NewTemplateState():
        return 'NewTemplateState';
      case _i6.TemplateEssential():
        return 'TemplateEssential';
      case _i7.PdfContent():
        return 'PdfContent';
      case _i8.PdfDeclaration():
        return 'PdfDeclaration';
      case _i9.PdfImplementationPayload():
        return 'PdfImplementationPayload';
      case _i10.SchemaDefinition():
        return 'SchemaDefinition';
      case _i11.SchemaPropertyArray():
        return 'SchemaPropertyArray';
      case _i11.SchemaPropertyBoolean():
        return 'SchemaPropertyBoolean';
      case _i11.SchemaPropertyDouble():
        return 'SchemaPropertyDouble';
      case _i11.SchemaPropertyEnum():
        return 'SchemaPropertyEnum';
      case _i11.SchemaPropertyInteger():
        return 'SchemaPropertyInteger';
      case _i11.SchemaPropertyObjectWithUndefinedProperties():
        return 'SchemaPropertyObjectWithUndefinedProperties';
      case _i11.SchemaPropertyString():
        return 'SchemaPropertyString';
      case _i11.SchemaPropertyStructuredObjectWithDefinedProperties():
        return 'SchemaPropertyStructuredObjectWithDefinedProperties';
      case _i12.ShoebillTemplateScaffold():
        return 'ShoebillTemplateScaffold';
      case _i13.ShoebillTemplateVersion():
        return 'ShoebillTemplateVersion';
      case _i14.ShoebillTemplateVersionImplementation():
        return 'ShoebillTemplateVersionImplementation';
      case _i15.ShoebillTemplateVersionInput():
        return 'ShoebillTemplateVersionInput';
      case _i16.AiThinkingChunk():
        return 'AiThinkingChunk';
      case _i17.ShoebillException():
        return 'ShoebillException';
      case _i18.SupportedLanguages():
        return 'SupportedLanguages';
      case _i19.TemplatePdf():
        return 'TemplatePdf';
      case _i20.Greeting():
        return 'Greeting';
    }
    className = _i23.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i24.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    if (data
        is ({
          _i21.AiThinkingChunk? aiThinkingChunk,
          _i22.TemplateEssential? template,
        })) {
      return '(,{AiThinkingChunk? aiThinkingChunk,TemplateEssential? template})';
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
    if (dataClassName == 'DeployReadyTemplateState') {
      return deserialize<_i5.DeployReadyTemplateState>(data['data']);
    }
    if (dataClassName == 'NewTemplateState') {
      return deserialize<_i5.NewTemplateState>(data['data']);
    }
    if (dataClassName == 'TemplateEssential') {
      return deserialize<_i6.TemplateEssential>(data['data']);
    }
    if (dataClassName == 'PdfContent') {
      return deserialize<_i7.PdfContent>(data['data']);
    }
    if (dataClassName == 'PdfDeclaration') {
      return deserialize<_i8.PdfDeclaration>(data['data']);
    }
    if (dataClassName == 'PdfImplementationPayload') {
      return deserialize<_i9.PdfImplementationPayload>(data['data']);
    }
    if (dataClassName == 'SchemaDefinition') {
      return deserialize<_i10.SchemaDefinition>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyArray') {
      return deserialize<_i11.SchemaPropertyArray>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyBoolean') {
      return deserialize<_i11.SchemaPropertyBoolean>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyDouble') {
      return deserialize<_i11.SchemaPropertyDouble>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyEnum') {
      return deserialize<_i11.SchemaPropertyEnum>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyInteger') {
      return deserialize<_i11.SchemaPropertyInteger>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyObjectWithUndefinedProperties') {
      return deserialize<_i11.SchemaPropertyObjectWithUndefinedProperties>(
        data['data'],
      );
    }
    if (dataClassName == 'SchemaPropertyString') {
      return deserialize<_i11.SchemaPropertyString>(data['data']);
    }
    if (dataClassName ==
        'SchemaPropertyStructuredObjectWithDefinedProperties') {
      return deserialize<
        _i11.SchemaPropertyStructuredObjectWithDefinedProperties
      >(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateScaffold') {
      return deserialize<_i12.ShoebillTemplateScaffold>(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateVersion') {
      return deserialize<_i13.ShoebillTemplateVersion>(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateVersionImplementation') {
      return deserialize<_i14.ShoebillTemplateVersionImplementation>(
        data['data'],
      );
    }
    if (dataClassName == 'ShoebillTemplateVersionInput') {
      return deserialize<_i15.ShoebillTemplateVersionInput>(data['data']);
    }
    if (dataClassName == 'AiThinkingChunk') {
      return deserialize<_i16.AiThinkingChunk>(data['data']);
    }
    if (dataClassName == 'ShoebillException') {
      return deserialize<_i17.ShoebillException>(data['data']);
    }
    if (dataClassName == 'SupportedLanguages') {
      return deserialize<_i18.SupportedLanguages>(data['data']);
    }
    if (dataClassName == 'TemplatePdf') {
      return deserialize<_i19.TemplatePdf>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i20.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i23.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i24.Protocol().deserializeByClassName(data);
    }
    if (dataClassName ==
        '(,{AiThinkingChunk? aiThinkingChunk,TemplateEssential? template})') {
      return deserialize<
        ({
          _i21.AiThinkingChunk? aiThinkingChunk,
          _i22.TemplateEssential? template,
        })
      >(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  /// Wraps serialized data with its class name so that it can be deserialized
  /// with [deserializeByClassName].
  ///
  /// Records and containers containing records will be return in their JSON representation in the returned map.
  @override
  Map<String, dynamic> wrapWithClassName(Object? data) {
    /// In case the value (to be streamed) contains a record or potentially empty non-String-keyed Map, we need to map it before it reaches the underlying JSON encode
    if (data != null && (data is Iterable || data is Map)) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapContainerToJson(data),
      };
    } else if (data is Record) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapRecordToJson(data),
      };
    }

    return super.wrapWithClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    if (record
        is ({
          _i21.AiThinkingChunk? aiThinkingChunk,
          _i22.TemplateEssential? template,
        })) {
      return {
        "n": {
          "aiThinkingChunk": record.aiThinkingChunk,
          "template": record.template,
        },
      };
    }
    try {
      return _i23.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i24.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }

  /// Maps container types (like [List], [Map], [Set]) containing
  /// [Record]s or non-String-keyed [Map]s to their JSON representation.
  ///
  /// It should not be called for [SerializableModel] types. These
  /// handle the "[Record] in container" mapping internally already.
  ///
  /// It is only supposed to be called from generated protocol code.
  ///
  /// Returns either a `List<dynamic>` (for List, Sets, and Maps with
  /// non-String keys) or a `Map<String, dynamic>` in case the input was
  /// a `Map<String, …>`.
  Object? mapContainerToJson(Object obj) {
    if (obj is! Iterable && obj is! Map) {
      throw ArgumentError.value(
        obj,
        'obj',
        'The object to serialize should be of type List, Map, or Set',
      );
    }

    dynamic mapIfNeeded(Object? obj) {
      return switch (obj) {
        Record record => mapRecordToJson(record),
        Iterable iterable => mapContainerToJson(iterable),
        Map map => mapContainerToJson(map),
        Object? value => value,
      };
    }

    switch (obj) {
      case Map<String, dynamic>():
        return {
          for (var entry in obj.entries) entry.key: mapIfNeeded(entry.value),
        };
      case Map():
        return [
          for (var entry in obj.entries)
            {
              'k': mapIfNeeded(entry.key),
              'v': mapIfNeeded(entry.value),
            },
        ];

      case Iterable():
        return [
          for (var e in obj) mapIfNeeded(e),
        ];
    }

    return obj;
  }
}

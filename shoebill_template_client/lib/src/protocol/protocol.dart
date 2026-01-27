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
import 'api/chat_session_related/entities/send_message_stream_response_item.dart'
    as _i2;
import 'api/chat_session_related/entities/create_template_essentials_result.dart'
    as _i3;
import 'api/chat_session_related/entities/messages/chat_actor.dart' as _i4;
import 'api/chat_session_related/entities/messages/chat_message.dart' as _i5;
import 'api/chat_session_related/entities/messages/chat_ui_style.dart' as _i6;
import 'api/chat_session_related/entities/new_schema_change_payload.dart'
    as _i7;
import 'api/chat_session_related/entities/template_current_state/template_current_state.dart'
    as _i8;
import 'api/chat_session_related/entities/template_essential.dart' as _i9;
import 'api/pdf_related/entities/pdf_content.dart' as _i10;
import 'api/pdf_related/entities/schema_definition.dart' as _i11;
import 'api/pdf_related/entities/schemas_implementations/schema_property.dart'
    as _i12;
import 'api/pdf_related/entities/template_entities/shoebill_template_baseline.dart'
    as _i13;
import 'api/pdf_related/entities/template_entities/shoebill_template_baseline_implementation.dart'
    as _i14;
import 'api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i15;
import 'api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i16;
import 'api/pdf_related/entities/template_entities/shoebill_template_version_input.dart'
    as _i17;
import 'entities/account/account.dart' as _i18;
import 'entities/others/ai_thinking_chunk.dart' as _i19;
import 'entities/others/shoebill_exception.dart' as _i20;
import 'entities/others/supported_languages.dart' as _i21;
import 'greetings/greeting.dart' as _i22;
import 'package:shoebill_template_client/src/protocol/api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i23;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i24;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i25;
export 'api/chat_session_related/entities/create_template_essentials_result.dart';
export 'api/chat_session_related/entities/messages/chat_actor.dart';
export 'api/chat_session_related/entities/messages/chat_message.dart';
export 'api/chat_session_related/entities/messages/chat_ui_style.dart';
export 'api/chat_session_related/entities/new_schema_change_payload.dart';
export 'api/chat_session_related/entities/send_message_stream_response_item.dart';
export 'api/chat_session_related/entities/template_current_state/template_current_state.dart';
export 'api/chat_session_related/entities/template_essential.dart';
export 'api/pdf_related/entities/pdf_content.dart';
export 'api/pdf_related/entities/schema_definition.dart';
export 'api/pdf_related/entities/schemas_implementations/schema_property.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_baseline.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_baseline_implementation.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_version.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_version_input.dart';
export 'entities/account/account.dart';
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

    if (t == _i2.ChatMessageResponse) {
      return _i2.ChatMessageResponse.fromJson(data) as T;
    }
    if (t == _i3.TemplateEssentialFinalResult) {
      return _i3.TemplateEssentialFinalResult.fromJson(data) as T;
    }
    if (t == _i3.TemplateEssentialThinkingResult) {
      return _i3.TemplateEssentialThinkingResult.fromJson(data) as T;
    }
    if (t == _i4.ChatActor) {
      return _i4.ChatActor.fromJson(data) as T;
    }
    if (t == _i5.ChatMessage) {
      return _i5.ChatMessage.fromJson(data) as T;
    }
    if (t == _i6.ChatUIStyle) {
      return _i6.ChatUIStyle.fromJson(data) as T;
    }
    if (t == _i7.NewSchemaChangePayload) {
      return _i7.NewSchemaChangePayload.fromJson(data) as T;
    }
    if (t == _i2.TemplateStateResponse) {
      return _i2.TemplateStateResponse.fromJson(data) as T;
    }
    if (t == _i8.DeployReadyTemplateState) {
      return _i8.DeployReadyTemplateState.fromJson(data) as T;
    }
    if (t == _i8.NewTemplateState) {
      return _i8.NewTemplateState.fromJson(data) as T;
    }
    if (t == _i9.TemplateEssential) {
      return _i9.TemplateEssential.fromJson(data) as T;
    }
    if (t == _i10.PdfContent) {
      return _i10.PdfContent.fromJson(data) as T;
    }
    if (t == _i11.SchemaDefinition) {
      return _i11.SchemaDefinition.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyArray) {
      return _i12.SchemaPropertyArray.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyBoolean) {
      return _i12.SchemaPropertyBoolean.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyDouble) {
      return _i12.SchemaPropertyDouble.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyEnum) {
      return _i12.SchemaPropertyEnum.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyInteger) {
      return _i12.SchemaPropertyInteger.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyObjectWithUndefinedProperties) {
      return _i12.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
          as T;
    }
    if (t == _i12.SchemaPropertyString) {
      return _i12.SchemaPropertyString.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyStructuredObjectWithDefinedProperties) {
      return _i12.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
            data,
          )
          as T;
    }
    if (t == _i13.ShoebillTemplateBaseline) {
      return _i13.ShoebillTemplateBaseline.fromJson(data) as T;
    }
    if (t == _i14.ShoebillTemplateBaselineImplementation) {
      return _i14.ShoebillTemplateBaselineImplementation.fromJson(data) as T;
    }
    if (t == _i15.ShoebillTemplateScaffold) {
      return _i15.ShoebillTemplateScaffold.fromJson(data) as T;
    }
    if (t == _i16.ShoebillTemplateVersion) {
      return _i16.ShoebillTemplateVersion.fromJson(data) as T;
    }
    if (t == _i17.ShoebillTemplateVersionInput) {
      return _i17.ShoebillTemplateVersionInput.fromJson(data) as T;
    }
    if (t == _i18.AccountInfo) {
      return _i18.AccountInfo.fromJson(data) as T;
    }
    if (t == _i19.AiThinkingChunk) {
      return _i19.AiThinkingChunk.fromJson(data) as T;
    }
    if (t == _i20.ShoebillException) {
      return _i20.ShoebillException.fromJson(data) as T;
    }
    if (t == _i21.SupportedLanguage) {
      return _i21.SupportedLanguage.fromJson(data) as T;
    }
    if (t == _i22.Greeting) {
      return _i22.Greeting.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ChatMessageResponse?>()) {
      return (data != null ? _i2.ChatMessageResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.TemplateEssentialFinalResult?>()) {
      return (data != null
              ? _i3.TemplateEssentialFinalResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i3.TemplateEssentialThinkingResult?>()) {
      return (data != null
              ? _i3.TemplateEssentialThinkingResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i4.ChatActor?>()) {
      return (data != null ? _i4.ChatActor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ChatMessage?>()) {
      return (data != null ? _i5.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ChatUIStyle?>()) {
      return (data != null ? _i6.ChatUIStyle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.NewSchemaChangePayload?>()) {
      return (data != null ? _i7.NewSchemaChangePayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i2.TemplateStateResponse?>()) {
      return (data != null ? _i2.TemplateStateResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.DeployReadyTemplateState?>()) {
      return (data != null ? _i8.DeployReadyTemplateState.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.NewTemplateState?>()) {
      return (data != null ? _i8.NewTemplateState.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.TemplateEssential?>()) {
      return (data != null ? _i9.TemplateEssential.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PdfContent?>()) {
      return (data != null ? _i10.PdfContent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.SchemaDefinition?>()) {
      return (data != null ? _i11.SchemaDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyArray?>()) {
      return (data != null ? _i12.SchemaPropertyArray.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyBoolean?>()) {
      return (data != null ? _i12.SchemaPropertyBoolean.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyDouble?>()) {
      return (data != null ? _i12.SchemaPropertyDouble.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyEnum?>()) {
      return (data != null ? _i12.SchemaPropertyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyInteger?>()) {
      return (data != null ? _i12.SchemaPropertyInteger.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyObjectWithUndefinedProperties?>()) {
      return (data != null
              ? _i12.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyString?>()) {
      return (data != null ? _i12.SchemaPropertyString.fromJson(data) : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              _i12.SchemaPropertyStructuredObjectWithDefinedProperties?
            >()) {
      return (data != null
              ? _i12.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.ShoebillTemplateBaseline?>()) {
      return (data != null
              ? _i13.ShoebillTemplateBaseline.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.ShoebillTemplateBaselineImplementation?>()) {
      return (data != null
              ? _i14.ShoebillTemplateBaselineImplementation.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.ShoebillTemplateScaffold?>()) {
      return (data != null
              ? _i15.ShoebillTemplateScaffold.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.ShoebillTemplateVersion?>()) {
      return (data != null ? _i16.ShoebillTemplateVersion.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.ShoebillTemplateVersionInput?>()) {
      return (data != null
              ? _i17.ShoebillTemplateVersionInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i18.AccountInfo?>()) {
      return (data != null ? _i18.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.AiThinkingChunk?>()) {
      return (data != null ? _i19.AiThinkingChunk.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.ShoebillException?>()) {
      return (data != null ? _i20.ShoebillException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.SupportedLanguage?>()) {
      return (data != null ? _i21.SupportedLanguage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Greeting?>()) {
      return (data != null ? _i22.Greeting.fromJson(data) : null) as T;
    }
    if (t == Map<String, _i12.SchemaProperty>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i12.SchemaProperty>(v),
            ),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i14.ShoebillTemplateBaselineImplementation>) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<_i14.ShoebillTemplateBaselineImplementation>(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _i1.getType<List<_i14.ShoebillTemplateBaselineImplementation>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            _i14.ShoebillTemplateBaselineImplementation
                          >(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i16.ShoebillTemplateVersion>) {
      return (data as List)
              .map((e) => deserialize<_i16.ShoebillTemplateVersion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i16.ShoebillTemplateVersion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i16.ShoebillTemplateVersion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i13.ShoebillTemplateBaseline>) {
      return (data as List)
              .map((e) => deserialize<_i13.ShoebillTemplateBaseline>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i13.ShoebillTemplateBaseline>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i13.ShoebillTemplateBaseline>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i15.ShoebillTemplateScaffold>) {
      return (data as List)
              .map((e) => deserialize<_i15.ShoebillTemplateScaffold>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i15.ShoebillTemplateScaffold>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i15.ShoebillTemplateScaffold>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i23.ShoebillTemplateScaffold>) {
      return (data as List)
              .map((e) => deserialize<_i23.ShoebillTemplateScaffold>(e))
              .toList()
          as T;
    }
    try {
      return _i24.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i25.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ChatMessageResponse => 'ChatMessageResponse',
      _i3.TemplateEssentialFinalResult => 'TemplateEssentialFinalResult',
      _i3.TemplateEssentialThinkingResult => 'TemplateEssentialThinkingResult',
      _i4.ChatActor => 'ChatActor',
      _i5.ChatMessage => 'ChatMessage',
      _i6.ChatUIStyle => 'ChatUIStyle',
      _i7.NewSchemaChangePayload => 'NewSchemaChangePayload',
      _i2.TemplateStateResponse => 'TemplateStateResponse',
      _i8.DeployReadyTemplateState => 'DeployReadyTemplateState',
      _i8.NewTemplateState => 'NewTemplateState',
      _i9.TemplateEssential => 'TemplateEssential',
      _i10.PdfContent => 'PdfContent',
      _i11.SchemaDefinition => 'SchemaDefinition',
      _i12.SchemaPropertyArray => 'SchemaPropertyArray',
      _i12.SchemaPropertyBoolean => 'SchemaPropertyBoolean',
      _i12.SchemaPropertyDouble => 'SchemaPropertyDouble',
      _i12.SchemaPropertyEnum => 'SchemaPropertyEnum',
      _i12.SchemaPropertyInteger => 'SchemaPropertyInteger',
      _i12.SchemaPropertyObjectWithUndefinedProperties =>
        'SchemaPropertyObjectWithUndefinedProperties',
      _i12.SchemaPropertyString => 'SchemaPropertyString',
      _i12.SchemaPropertyStructuredObjectWithDefinedProperties =>
        'SchemaPropertyStructuredObjectWithDefinedProperties',
      _i13.ShoebillTemplateBaseline => 'ShoebillTemplateBaseline',
      _i14.ShoebillTemplateBaselineImplementation =>
        'ShoebillTemplateBaselineImplementation',
      _i15.ShoebillTemplateScaffold => 'ShoebillTemplateScaffold',
      _i16.ShoebillTemplateVersion => 'ShoebillTemplateVersion',
      _i17.ShoebillTemplateVersionInput => 'ShoebillTemplateVersionInput',
      _i18.AccountInfo => 'AccountInfo',
      _i19.AiThinkingChunk => 'AiThinkingChunk',
      _i20.ShoebillException => 'ShoebillException',
      _i21.SupportedLanguage => 'SupportedLanguage',
      _i22.Greeting => 'Greeting',
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
      case _i2.ChatMessageResponse():
        return 'ChatMessageResponse';
      case _i3.TemplateEssentialFinalResult():
        return 'TemplateEssentialFinalResult';
      case _i3.TemplateEssentialThinkingResult():
        return 'TemplateEssentialThinkingResult';
      case _i4.ChatActor():
        return 'ChatActor';
      case _i5.ChatMessage():
        return 'ChatMessage';
      case _i6.ChatUIStyle():
        return 'ChatUIStyle';
      case _i7.NewSchemaChangePayload():
        return 'NewSchemaChangePayload';
      case _i2.TemplateStateResponse():
        return 'TemplateStateResponse';
      case _i8.DeployReadyTemplateState():
        return 'DeployReadyTemplateState';
      case _i8.NewTemplateState():
        return 'NewTemplateState';
      case _i9.TemplateEssential():
        return 'TemplateEssential';
      case _i10.PdfContent():
        return 'PdfContent';
      case _i11.SchemaDefinition():
        return 'SchemaDefinition';
      case _i12.SchemaPropertyArray():
        return 'SchemaPropertyArray';
      case _i12.SchemaPropertyBoolean():
        return 'SchemaPropertyBoolean';
      case _i12.SchemaPropertyDouble():
        return 'SchemaPropertyDouble';
      case _i12.SchemaPropertyEnum():
        return 'SchemaPropertyEnum';
      case _i12.SchemaPropertyInteger():
        return 'SchemaPropertyInteger';
      case _i12.SchemaPropertyObjectWithUndefinedProperties():
        return 'SchemaPropertyObjectWithUndefinedProperties';
      case _i12.SchemaPropertyString():
        return 'SchemaPropertyString';
      case _i12.SchemaPropertyStructuredObjectWithDefinedProperties():
        return 'SchemaPropertyStructuredObjectWithDefinedProperties';
      case _i13.ShoebillTemplateBaseline():
        return 'ShoebillTemplateBaseline';
      case _i14.ShoebillTemplateBaselineImplementation():
        return 'ShoebillTemplateBaselineImplementation';
      case _i15.ShoebillTemplateScaffold():
        return 'ShoebillTemplateScaffold';
      case _i16.ShoebillTemplateVersion():
        return 'ShoebillTemplateVersion';
      case _i17.ShoebillTemplateVersionInput():
        return 'ShoebillTemplateVersionInput';
      case _i18.AccountInfo():
        return 'AccountInfo';
      case _i19.AiThinkingChunk():
        return 'AiThinkingChunk';
      case _i20.ShoebillException():
        return 'ShoebillException';
      case _i21.SupportedLanguage():
        return 'SupportedLanguage';
      case _i22.Greeting():
        return 'Greeting';
    }
    className = _i24.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i25.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'ChatMessageResponse') {
      return deserialize<_i2.ChatMessageResponse>(data['data']);
    }
    if (dataClassName == 'TemplateEssentialFinalResult') {
      return deserialize<_i3.TemplateEssentialFinalResult>(data['data']);
    }
    if (dataClassName == 'TemplateEssentialThinkingResult') {
      return deserialize<_i3.TemplateEssentialThinkingResult>(data['data']);
    }
    if (dataClassName == 'ChatActor') {
      return deserialize<_i4.ChatActor>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i5.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatUIStyle') {
      return deserialize<_i6.ChatUIStyle>(data['data']);
    }
    if (dataClassName == 'NewSchemaChangePayload') {
      return deserialize<_i7.NewSchemaChangePayload>(data['data']);
    }
    if (dataClassName == 'TemplateStateResponse') {
      return deserialize<_i2.TemplateStateResponse>(data['data']);
    }
    if (dataClassName == 'DeployReadyTemplateState') {
      return deserialize<_i8.DeployReadyTemplateState>(data['data']);
    }
    if (dataClassName == 'NewTemplateState') {
      return deserialize<_i8.NewTemplateState>(data['data']);
    }
    if (dataClassName == 'TemplateEssential') {
      return deserialize<_i9.TemplateEssential>(data['data']);
    }
    if (dataClassName == 'PdfContent') {
      return deserialize<_i10.PdfContent>(data['data']);
    }
    if (dataClassName == 'SchemaDefinition') {
      return deserialize<_i11.SchemaDefinition>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyArray') {
      return deserialize<_i12.SchemaPropertyArray>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyBoolean') {
      return deserialize<_i12.SchemaPropertyBoolean>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyDouble') {
      return deserialize<_i12.SchemaPropertyDouble>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyEnum') {
      return deserialize<_i12.SchemaPropertyEnum>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyInteger') {
      return deserialize<_i12.SchemaPropertyInteger>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyObjectWithUndefinedProperties') {
      return deserialize<_i12.SchemaPropertyObjectWithUndefinedProperties>(
        data['data'],
      );
    }
    if (dataClassName == 'SchemaPropertyString') {
      return deserialize<_i12.SchemaPropertyString>(data['data']);
    }
    if (dataClassName ==
        'SchemaPropertyStructuredObjectWithDefinedProperties') {
      return deserialize<
        _i12.SchemaPropertyStructuredObjectWithDefinedProperties
      >(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateBaseline') {
      return deserialize<_i13.ShoebillTemplateBaseline>(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateBaselineImplementation') {
      return deserialize<_i14.ShoebillTemplateBaselineImplementation>(
        data['data'],
      );
    }
    if (dataClassName == 'ShoebillTemplateScaffold') {
      return deserialize<_i15.ShoebillTemplateScaffold>(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateVersion') {
      return deserialize<_i16.ShoebillTemplateVersion>(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateVersionInput') {
      return deserialize<_i17.ShoebillTemplateVersionInput>(data['data']);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i18.AccountInfo>(data['data']);
    }
    if (dataClassName == 'AiThinkingChunk') {
      return deserialize<_i19.AiThinkingChunk>(data['data']);
    }
    if (dataClassName == 'ShoebillException') {
      return deserialize<_i20.ShoebillException>(data['data']);
    }
    if (dataClassName == 'SupportedLanguage') {
      return deserialize<_i21.SupportedLanguage>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i22.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i24.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i25.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
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
    try {
      return _i24.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i25.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

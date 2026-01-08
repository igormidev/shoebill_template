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
import 'api/chat_session_related/messages/chat_actor.dart' as _i2;
import 'api/chat_session_related/messages/chat_message.dart' as _i3;
import 'api/chat_session_related/messages/chat_ui_style.dart' as _i4;
import 'api/pdf_related/entities/pdf_content.dart' as _i5;
import 'api/pdf_related/entities/pdf_implementation_payload.dart' as _i6;
import 'api/pdf_related/entities/schema_definition.dart' as _i7;
import 'api/pdf_related/entities/schemas_implementations/schema_property.dart'
    as _i8;
import 'entities/others/shoebill_exception.dart' as _i9;
import 'entities/others/supported_languages.dart' as _i10;
import 'entities/template/shoebill_template.dart' as _i11;
import 'greetings/greeting.dart' as _i12;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i13;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i14;
export 'api/chat_session_related/messages/chat_actor.dart';
export 'api/chat_session_related/messages/chat_message.dart';
export 'api/chat_session_related/messages/chat_ui_style.dart';
export 'api/pdf_related/entities/pdf_content.dart';
export 'api/pdf_related/entities/pdf_implementation_payload.dart';
export 'api/pdf_related/entities/schema_definition.dart';
export 'api/pdf_related/entities/schemas_implementations/schema_property.dart';
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
    if (t == _i5.PdfContent) {
      return _i5.PdfContent.fromJson(data) as T;
    }
    if (t == _i6.PdfImplementationPayload) {
      return _i6.PdfImplementationPayload.fromJson(data) as T;
    }
    if (t == _i7.SchemaDefinition) {
      return _i7.SchemaDefinition.fromJson(data) as T;
    }
    if (t == _i8.SchemaPropertyArray) {
      return _i8.SchemaPropertyArray.fromJson(data) as T;
    }
    if (t == _i8.SchemaPropertyBoolean) {
      return _i8.SchemaPropertyBoolean.fromJson(data) as T;
    }
    if (t == _i8.SchemaPropertyDouble) {
      return _i8.SchemaPropertyDouble.fromJson(data) as T;
    }
    if (t == _i8.SchemaPropertyEnum) {
      return _i8.SchemaPropertyEnum.fromJson(data) as T;
    }
    if (t == _i8.SchemaPropertyInteger) {
      return _i8.SchemaPropertyInteger.fromJson(data) as T;
    }
    if (t == _i8.SchemaPropertyObjectWithUndefinedProperties) {
      return _i8.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
          as T;
    }
    if (t == _i8.SchemaPropertyString) {
      return _i8.SchemaPropertyString.fromJson(data) as T;
    }
    if (t == _i8.SchemaPropertyStructuredObjectWithDefinedProperties) {
      return _i8.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
            data,
          )
          as T;
    }
    if (t == _i9.ShoebillException) {
      return _i9.ShoebillException.fromJson(data) as T;
    }
    if (t == _i10.SupportedLanguages) {
      return _i10.SupportedLanguages.fromJson(data) as T;
    }
    if (t == _i11.TemplatePdf) {
      return _i11.TemplatePdf.fromJson(data) as T;
    }
    if (t == _i12.Greeting) {
      return _i12.Greeting.fromJson(data) as T;
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
    if (t == _i1.getType<_i5.PdfContent?>()) {
      return (data != null ? _i5.PdfContent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.PdfImplementationPayload?>()) {
      return (data != null ? _i6.PdfImplementationPayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.SchemaDefinition?>()) {
      return (data != null ? _i7.SchemaDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.SchemaPropertyArray?>()) {
      return (data != null ? _i8.SchemaPropertyArray.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.SchemaPropertyBoolean?>()) {
      return (data != null ? _i8.SchemaPropertyBoolean.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.SchemaPropertyDouble?>()) {
      return (data != null ? _i8.SchemaPropertyDouble.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.SchemaPropertyEnum?>()) {
      return (data != null ? _i8.SchemaPropertyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.SchemaPropertyInteger?>()) {
      return (data != null ? _i8.SchemaPropertyInteger.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.SchemaPropertyObjectWithUndefinedProperties?>()) {
      return (data != null
              ? _i8.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i8.SchemaPropertyString?>()) {
      return (data != null ? _i8.SchemaPropertyString.fromJson(data) : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              _i8.SchemaPropertyStructuredObjectWithDefinedProperties?
            >()) {
      return (data != null
              ? _i8.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _i1.getType<_i9.ShoebillException?>()) {
      return (data != null ? _i9.ShoebillException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.SupportedLanguages?>()) {
      return (data != null ? _i10.SupportedLanguages.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.TemplatePdf?>()) {
      return (data != null ? _i11.TemplatePdf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Greeting?>()) {
      return (data != null ? _i12.Greeting.fromJson(data) : null) as T;
    }
    if (t == Map<String, _i8.SchemaProperty>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i8.SchemaProperty>(v),
            ),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i13.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i14.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ChatActor => 'ChatActor',
      _i3.ChatMessage => 'ChatMessage',
      _i4.ChatUIStyle => 'ChatUIStyle',
      _i5.PdfContent => 'PdfContent',
      _i6.PdfImplementationPayload => 'PdfImplementationPayload',
      _i7.SchemaDefinition => 'SchemaDefinition',
      _i8.SchemaPropertyArray => 'SchemaPropertyArray',
      _i8.SchemaPropertyBoolean => 'SchemaPropertyBoolean',
      _i8.SchemaPropertyDouble => 'SchemaPropertyDouble',
      _i8.SchemaPropertyEnum => 'SchemaPropertyEnum',
      _i8.SchemaPropertyInteger => 'SchemaPropertyInteger',
      _i8.SchemaPropertyObjectWithUndefinedProperties =>
        'SchemaPropertyObjectWithUndefinedProperties',
      _i8.SchemaPropertyString => 'SchemaPropertyString',
      _i8.SchemaPropertyStructuredObjectWithDefinedProperties =>
        'SchemaPropertyStructuredObjectWithDefinedProperties',
      _i9.ShoebillException => 'ShoebillException',
      _i10.SupportedLanguages => 'SupportedLanguages',
      _i11.TemplatePdf => 'TemplatePdf',
      _i12.Greeting => 'Greeting',
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
      case _i5.PdfContent():
        return 'PdfContent';
      case _i6.PdfImplementationPayload():
        return 'PdfImplementationPayload';
      case _i7.SchemaDefinition():
        return 'SchemaDefinition';
      case _i8.SchemaPropertyArray():
        return 'SchemaPropertyArray';
      case _i8.SchemaPropertyBoolean():
        return 'SchemaPropertyBoolean';
      case _i8.SchemaPropertyDouble():
        return 'SchemaPropertyDouble';
      case _i8.SchemaPropertyEnum():
        return 'SchemaPropertyEnum';
      case _i8.SchemaPropertyInteger():
        return 'SchemaPropertyInteger';
      case _i8.SchemaPropertyObjectWithUndefinedProperties():
        return 'SchemaPropertyObjectWithUndefinedProperties';
      case _i8.SchemaPropertyString():
        return 'SchemaPropertyString';
      case _i8.SchemaPropertyStructuredObjectWithDefinedProperties():
        return 'SchemaPropertyStructuredObjectWithDefinedProperties';
      case _i9.ShoebillException():
        return 'ShoebillException';
      case _i10.SupportedLanguages():
        return 'SupportedLanguages';
      case _i11.TemplatePdf():
        return 'TemplatePdf';
      case _i12.Greeting():
        return 'Greeting';
    }
    className = _i13.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i14.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'PdfContent') {
      return deserialize<_i5.PdfContent>(data['data']);
    }
    if (dataClassName == 'PdfImplementationPayload') {
      return deserialize<_i6.PdfImplementationPayload>(data['data']);
    }
    if (dataClassName == 'SchemaDefinition') {
      return deserialize<_i7.SchemaDefinition>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyArray') {
      return deserialize<_i8.SchemaPropertyArray>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyBoolean') {
      return deserialize<_i8.SchemaPropertyBoolean>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyDouble') {
      return deserialize<_i8.SchemaPropertyDouble>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyEnum') {
      return deserialize<_i8.SchemaPropertyEnum>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyInteger') {
      return deserialize<_i8.SchemaPropertyInteger>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyObjectWithUndefinedProperties') {
      return deserialize<_i8.SchemaPropertyObjectWithUndefinedProperties>(
        data['data'],
      );
    }
    if (dataClassName == 'SchemaPropertyString') {
      return deserialize<_i8.SchemaPropertyString>(data['data']);
    }
    if (dataClassName ==
        'SchemaPropertyStructuredObjectWithDefinedProperties') {
      return deserialize<
        _i8.SchemaPropertyStructuredObjectWithDefinedProperties
      >(data['data']);
    }
    if (dataClassName == 'ShoebillException') {
      return deserialize<_i9.ShoebillException>(data['data']);
    }
    if (dataClassName == 'SupportedLanguages') {
      return deserialize<_i10.SupportedLanguages>(data['data']);
    }
    if (dataClassName == 'TemplatePdf') {
      return deserialize<_i11.TemplatePdf>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i12.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i13.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i14.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

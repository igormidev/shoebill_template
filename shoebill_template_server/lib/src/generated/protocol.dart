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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'api/chat_session_related/messages/chat_actor.dart' as _i5;
import 'api/chat_session_related/messages/chat_message.dart' as _i6;
import 'api/chat_session_related/messages/chat_ui_style.dart' as _i7;
import 'entities/others/shoebill_exception.dart' as _i8;
import 'entities/others/supported_languages.dart' as _i9;
import 'entities/template/shoebill_template.dart' as _i10;
import 'greetings/greeting.dart' as _i11;
export 'api/chat_session_related/messages/chat_actor.dart';
export 'api/chat_session_related/messages/chat_message.dart';
export 'api/chat_session_related/messages/chat_ui_style.dart';
export 'entities/others/shoebill_exception.dart';
export 'entities/others/supported_languages.dart';
export 'entities/template/shoebill_template.dart';
export 'greetings/greeting.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'template_pdf',
      dartName: 'TemplatePdf',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'pythonGeneratorScript',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'template_pdf_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i5.ChatActor) {
      return _i5.ChatActor.fromJson(data) as T;
    }
    if (t == _i6.ChatMessage) {
      return _i6.ChatMessage.fromJson(data) as T;
    }
    if (t == _i7.ChatUIStyle) {
      return _i7.ChatUIStyle.fromJson(data) as T;
    }
    if (t == _i8.ShoebillException) {
      return _i8.ShoebillException.fromJson(data) as T;
    }
    if (t == _i9.SupportedLanguages) {
      return _i9.SupportedLanguages.fromJson(data) as T;
    }
    if (t == _i10.TemplatePdf) {
      return _i10.TemplatePdf.fromJson(data) as T;
    }
    if (t == _i11.Greeting) {
      return _i11.Greeting.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ChatActor?>()) {
      return (data != null ? _i5.ChatActor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ChatMessage?>()) {
      return (data != null ? _i6.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ChatUIStyle?>()) {
      return (data != null ? _i7.ChatUIStyle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ShoebillException?>()) {
      return (data != null ? _i8.ShoebillException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.SupportedLanguages?>()) {
      return (data != null ? _i9.SupportedLanguages.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.TemplatePdf?>()) {
      return (data != null ? _i10.TemplatePdf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Greeting?>()) {
      return (data != null ? _i11.Greeting.fromJson(data) : null) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.ChatActor => 'ChatActor',
      _i6.ChatMessage => 'ChatMessage',
      _i7.ChatUIStyle => 'ChatUIStyle',
      _i8.ShoebillException => 'ShoebillException',
      _i9.SupportedLanguages => 'SupportedLanguages',
      _i10.TemplatePdf => 'TemplatePdf',
      _i11.Greeting => 'Greeting',
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
      case _i5.ChatActor():
        return 'ChatActor';
      case _i6.ChatMessage():
        return 'ChatMessage';
      case _i7.ChatUIStyle():
        return 'ChatUIStyle';
      case _i8.ShoebillException():
        return 'ShoebillException';
      case _i9.SupportedLanguages():
        return 'SupportedLanguages';
      case _i10.TemplatePdf():
        return 'TemplatePdf';
      case _i11.Greeting():
        return 'Greeting';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
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
      return deserialize<_i5.ChatActor>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i6.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatUIStyle') {
      return deserialize<_i7.ChatUIStyle>(data['data']);
    }
    if (dataClassName == 'ShoebillException') {
      return deserialize<_i8.ShoebillException>(data['data']);
    }
    if (dataClassName == 'SupportedLanguages') {
      return deserialize<_i9.SupportedLanguages>(data['data']);
    }
    if (dataClassName == 'TemplatePdf') {
      return deserialize<_i10.TemplatePdf>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i11.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i10.TemplatePdf:
        return _i10.TemplatePdf.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'shoebill_template';
}

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
import 'entities/others/shoebill_exception.dart' as _i5;
import 'entities/template/shoebill_template.dart' as _i6;
import 'greetings/greeting.dart' as _i7;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i8;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i9;
export 'api/chat_session_related/messages/chat_actor.dart';
export 'api/chat_session_related/messages/chat_message.dart';
export 'api/chat_session_related/messages/chat_ui_style.dart';
export 'entities/others/shoebill_exception.dart';
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
    if (t == _i5.ShoebillException) {
      return _i5.ShoebillException.fromJson(data) as T;
    }
    if (t == _i6.TemplatePdf) {
      return _i6.TemplatePdf.fromJson(data) as T;
    }
    if (t == _i7.Greeting) {
      return _i7.Greeting.fromJson(data) as T;
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
    if (t == _i1.getType<_i5.ShoebillException?>()) {
      return (data != null ? _i5.ShoebillException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.TemplatePdf?>()) {
      return (data != null ? _i6.TemplatePdf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Greeting?>()) {
      return (data != null ? _i7.Greeting.fromJson(data) : null) as T;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i9.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ChatActor => 'ChatActor',
      _i3.ChatMessage => 'ChatMessage',
      _i4.ChatUIStyle => 'ChatUIStyle',
      _i5.ShoebillException => 'ShoebillException',
      _i6.TemplatePdf => 'TemplatePdf',
      _i7.Greeting => 'Greeting',
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
      case _i5.ShoebillException():
        return 'ShoebillException';
      case _i6.TemplatePdf():
        return 'TemplatePdf';
      case _i7.Greeting():
        return 'Greeting';
    }
    className = _i8.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i9.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'ShoebillException') {
      return deserialize<_i5.ShoebillException>(data['data']);
    }
    if (dataClassName == 'TemplatePdf') {
      return deserialize<_i6.TemplatePdf>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i7.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i8.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i9.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

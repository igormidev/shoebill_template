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
import '../../../api/chat_session_related/messages/chat_actor.dart' as _i2;
import '../../../api/chat_session_related/messages/chat_ui_style.dart' as _i3;

abstract class ChatMessage implements _i1.SerializableModel {
  ChatMessage._({
    required this.role,
    required this.style,
    DateTime? timestamp,
    required this.content,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ChatMessage({
    required _i2.ChatActor role,
    required _i3.ChatUIStyle style,
    DateTime? timestamp,
    required String content,
  }) = _ChatMessageImpl;

  factory ChatMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessage(
      role: _i2.ChatActor.fromJson((jsonSerialization['role'] as String)),
      style: _i3.ChatUIStyle.fromJson((jsonSerialization['style'] as String)),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      content: jsonSerialization['content'] as String,
    );
  }

  _i2.ChatActor role;

  _i3.ChatUIStyle style;

  DateTime timestamp;

  String content;

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessage copyWith({
    _i2.ChatActor? role,
    _i3.ChatUIStyle? style,
    DateTime? timestamp,
    String? content,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessage',
      'role': role.toJson(),
      'style': style.toJson(),
      'timestamp': timestamp.toJson(),
      'content': content,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatMessageImpl extends ChatMessage {
  _ChatMessageImpl({
    required _i2.ChatActor role,
    required _i3.ChatUIStyle style,
    DateTime? timestamp,
    required String content,
  }) : super._(
         role: role,
         style: style,
         timestamp: timestamp,
         content: content,
       );

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessage copyWith({
    _i2.ChatActor? role,
    _i3.ChatUIStyle? style,
    DateTime? timestamp,
    String? content,
  }) {
    return ChatMessage(
      role: role ?? this.role,
      style: style ?? this.style,
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
    );
  }
}

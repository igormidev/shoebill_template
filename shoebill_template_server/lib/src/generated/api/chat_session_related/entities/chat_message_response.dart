/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'send_message_stream_response_item.dart';

abstract class ChatMessageResponse extends _i1.SendMessageStreamResponseItem
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  ChatMessageResponse._({required this.message});

  factory ChatMessageResponse({required _i3.ChatMessage message}) =
      _ChatMessageResponseImpl;

  factory ChatMessageResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessageResponse(
      message: _i4.Protocol().deserialize<_i3.ChatMessage>(
        jsonSerialization['message'],
      ),
    );
  }

  _i3.ChatMessage message;

  /// Returns a shallow copy of this [ChatMessageResponse]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChatMessageResponse copyWith({_i3.ChatMessage? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessageResponse',
      'message': message.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatMessageResponse',
      'message': message.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _ChatMessageResponseImpl extends ChatMessageResponse {
  _ChatMessageResponseImpl({required _i3.ChatMessage message})
    : super._(message: message);

  /// Returns a shallow copy of this [ChatMessageResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChatMessageResponse copyWith({_i3.ChatMessage? message}) {
    return ChatMessageResponse(message: message ?? this.message.copyWith());
  }
}

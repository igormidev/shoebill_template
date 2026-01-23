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

abstract class TemplateStateResponse extends _i1.SendMessageStreamResponseItem
    implements _i2.SerializableModel {
  TemplateStateResponse._({required this.currentState});

  factory TemplateStateResponse({
    required _i5.TemplateCurrentState currentState,
  }) = _TemplateStateResponseImpl;

  factory TemplateStateResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TemplateStateResponse(
      currentState: _i4.Protocol().deserialize<_i5.TemplateCurrentState>(
        jsonSerialization['currentState'],
      ),
    );
  }

  _i5.TemplateCurrentState currentState;

  /// Returns a shallow copy of this [TemplateStateResponse]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  TemplateStateResponse copyWith({_i5.TemplateCurrentState? currentState});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TemplateStateResponse',
      'currentState': currentState.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _TemplateStateResponseImpl extends TemplateStateResponse {
  _TemplateStateResponseImpl({required _i5.TemplateCurrentState currentState})
    : super._(currentState: currentState);

  /// Returns a shallow copy of this [TemplateStateResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  TemplateStateResponse copyWith({_i5.TemplateCurrentState? currentState}) {
    return TemplateStateResponse(
      currentState: currentState ?? this.currentState.copyWith(),
    );
  }
}

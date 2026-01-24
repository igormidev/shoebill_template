/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'create_template_essentials_result.dart';

abstract class TemplateEssentialThinkingResult
    extends _i1.CreateTemplateEssentialsResult
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  TemplateEssentialThinkingResult._({required this.thinkingChunk});

  factory TemplateEssentialThinkingResult({
    required _i5.AiThinkingChunk thinkingChunk,
  }) = _TemplateEssentialThinkingResultImpl;

  factory TemplateEssentialThinkingResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TemplateEssentialThinkingResult(
      thinkingChunk: _i4.Protocol().deserialize<_i5.AiThinkingChunk>(
        jsonSerialization['thinkingChunk'],
      ),
    );
  }

  _i5.AiThinkingChunk thinkingChunk;

  /// Returns a shallow copy of this [TemplateEssentialThinkingResult]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  TemplateEssentialThinkingResult copyWith({
    _i5.AiThinkingChunk? thinkingChunk,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TemplateEssentialThinkingResult',
      'thinkingChunk': thinkingChunk.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TemplateEssentialThinkingResult',
      'thinkingChunk': thinkingChunk.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _TemplateEssentialThinkingResultImpl
    extends TemplateEssentialThinkingResult {
  _TemplateEssentialThinkingResultImpl({
    required _i5.AiThinkingChunk thinkingChunk,
  }) : super._(thinkingChunk: thinkingChunk);

  /// Returns a shallow copy of this [TemplateEssentialThinkingResult]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  TemplateEssentialThinkingResult copyWith({
    _i5.AiThinkingChunk? thinkingChunk,
  }) {
    return TemplateEssentialThinkingResult(
      thinkingChunk: thinkingChunk ?? this.thinkingChunk.copyWith(),
    );
  }
}

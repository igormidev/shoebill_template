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

abstract class TemplateEssentialFinalResult
    extends _i1.CreateTemplateEssentialsResult
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  TemplateEssentialFinalResult._({required this.template});

  factory TemplateEssentialFinalResult({
    required _i3.TemplateEssential template,
  }) = _TemplateEssentialFinalResultImpl;

  factory TemplateEssentialFinalResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TemplateEssentialFinalResult(
      template: _i4.Protocol().deserialize<_i3.TemplateEssential>(
        jsonSerialization['template'],
      ),
    );
  }

  _i3.TemplateEssential template;

  /// Returns a shallow copy of this [TemplateEssentialFinalResult]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  TemplateEssentialFinalResult copyWith({_i3.TemplateEssential? template});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TemplateEssentialFinalResult',
      'template': template.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TemplateEssentialFinalResult',
      'template': template.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _TemplateEssentialFinalResultImpl extends TemplateEssentialFinalResult {
  _TemplateEssentialFinalResultImpl({required _i3.TemplateEssential template})
    : super._(template: template);

  /// Returns a shallow copy of this [TemplateEssentialFinalResult]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  TemplateEssentialFinalResult copyWith({_i3.TemplateEssential? template}) {
    return TemplateEssentialFinalResult(
      template: template ?? this.template.copyWith(),
    );
  }
}

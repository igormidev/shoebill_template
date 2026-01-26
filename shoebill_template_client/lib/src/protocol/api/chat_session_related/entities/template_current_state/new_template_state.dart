/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'template_current_state.dart';

abstract class NewTemplateState extends _i1.TemplateCurrentState
    implements _i2.SerializableModel {
  NewTemplateState._({
    required this.pdfContent,
    required this.schemaDefinition,
    required this.referenceLanguage,
    required this.referenceStringifiedPayloadJson,
  });

  factory NewTemplateState({
    required _i3.PdfContent pdfContent,
    required _i4.SchemaDefinition schemaDefinition,
    required _i5.SupportedLanguage referenceLanguage,
    required String referenceStringifiedPayloadJson,
  }) = _NewTemplateStateImpl;

  factory NewTemplateState.fromJson(Map<String, dynamic> jsonSerialization) {
    return NewTemplateState(
      pdfContent: _i6.Protocol().deserialize<_i3.PdfContent>(
        jsonSerialization['pdfContent'],
      ),
      schemaDefinition: _i6.Protocol().deserialize<_i4.SchemaDefinition>(
        jsonSerialization['schemaDefinition'],
      ),
      referenceLanguage: _i5.SupportedLanguage.fromJson(
        (jsonSerialization['referenceLanguage'] as String),
      ),
      referenceStringifiedPayloadJson:
          jsonSerialization['referenceStringifiedPayloadJson'] as String,
    );
  }

  _i3.PdfContent pdfContent;

  _i4.SchemaDefinition schemaDefinition;

  _i5.SupportedLanguage referenceLanguage;

  String referenceStringifiedPayloadJson;

  /// Returns a shallow copy of this [NewTemplateState]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  NewTemplateState copyWith({
    _i3.PdfContent? pdfContent,
    _i4.SchemaDefinition? schemaDefinition,
    _i5.SupportedLanguage? referenceLanguage,
    String? referenceStringifiedPayloadJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NewTemplateState',
      'pdfContent': pdfContent.toJson(),
      'schemaDefinition': schemaDefinition.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'referenceStringifiedPayloadJson': referenceStringifiedPayloadJson,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _NewTemplateStateImpl extends NewTemplateState {
  _NewTemplateStateImpl({
    required _i3.PdfContent pdfContent,
    required _i4.SchemaDefinition schemaDefinition,
    required _i5.SupportedLanguage referenceLanguage,
    required String referenceStringifiedPayloadJson,
  }) : super._(
         pdfContent: pdfContent,
         schemaDefinition: schemaDefinition,
         referenceLanguage: referenceLanguage,
         referenceStringifiedPayloadJson: referenceStringifiedPayloadJson,
       );

  /// Returns a shallow copy of this [NewTemplateState]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  NewTemplateState copyWith({
    _i3.PdfContent? pdfContent,
    _i4.SchemaDefinition? schemaDefinition,
    _i5.SupportedLanguage? referenceLanguage,
    String? referenceStringifiedPayloadJson,
  }) {
    return NewTemplateState(
      pdfContent: pdfContent ?? this.pdfContent.copyWith(),
      schemaDefinition: schemaDefinition ?? this.schemaDefinition.copyWith(),
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      referenceStringifiedPayloadJson:
          referenceStringifiedPayloadJson ??
          this.referenceStringifiedPayloadJson,
    );
  }
}

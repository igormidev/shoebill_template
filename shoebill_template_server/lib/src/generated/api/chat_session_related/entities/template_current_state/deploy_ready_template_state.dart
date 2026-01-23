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

abstract class DeployReadyTemplateState extends _i1.TemplateCurrentState
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  DeployReadyTemplateState._({
    required this.pdfContent,
    required this.schemaDefinition,
    required this.referenceLanguage,
    required this.htmlContent,
    required this.cssContent,
    required this.referenceStringifiedPayloadJson,
  });

  factory DeployReadyTemplateState({
    required _i3.PdfContent pdfContent,
    required _i4.SchemaDefinition schemaDefinition,
    required _i5.SupportedLanguages referenceLanguage,
    required String htmlContent,
    required String cssContent,
    required String referenceStringifiedPayloadJson,
  }) = _DeployReadyTemplateStateImpl;

  factory DeployReadyTemplateState.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeployReadyTemplateState(
      pdfContent: _i6.Protocol().deserialize<_i3.PdfContent>(
        jsonSerialization['pdfContent'],
      ),
      schemaDefinition: _i6.Protocol().deserialize<_i4.SchemaDefinition>(
        jsonSerialization['schemaDefinition'],
      ),
      referenceLanguage: _i5.SupportedLanguages.fromJson(
        (jsonSerialization['referenceLanguage'] as String),
      ),
      htmlContent: jsonSerialization['htmlContent'] as String,
      cssContent: jsonSerialization['cssContent'] as String,
      referenceStringifiedPayloadJson:
          jsonSerialization['referenceStringifiedPayloadJson'] as String,
    );
  }

  _i3.PdfContent pdfContent;

  _i4.SchemaDefinition schemaDefinition;

  _i5.SupportedLanguages referenceLanguage;

  String htmlContent;

  String cssContent;

  String referenceStringifiedPayloadJson;

  /// Returns a shallow copy of this [DeployReadyTemplateState]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  DeployReadyTemplateState copyWith({
    _i3.PdfContent? pdfContent,
    _i4.SchemaDefinition? schemaDefinition,
    _i5.SupportedLanguages? referenceLanguage,
    String? htmlContent,
    String? cssContent,
    String? referenceStringifiedPayloadJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeployReadyTemplateState',
      'pdfContent': pdfContent.toJson(),
      'schemaDefinition': schemaDefinition.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'htmlContent': htmlContent,
      'cssContent': cssContent,
      'referenceStringifiedPayloadJson': referenceStringifiedPayloadJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeployReadyTemplateState',
      'pdfContent': pdfContent.toJsonForProtocol(),
      'schemaDefinition': schemaDefinition.toJsonForProtocol(),
      'referenceLanguage': referenceLanguage.toJson(),
      'htmlContent': htmlContent,
      'cssContent': cssContent,
      'referenceStringifiedPayloadJson': referenceStringifiedPayloadJson,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _DeployReadyTemplateStateImpl extends DeployReadyTemplateState {
  _DeployReadyTemplateStateImpl({
    required _i3.PdfContent pdfContent,
    required _i4.SchemaDefinition schemaDefinition,
    required _i5.SupportedLanguages referenceLanguage,
    required String htmlContent,
    required String cssContent,
    required String referenceStringifiedPayloadJson,
  }) : super._(
         pdfContent: pdfContent,
         schemaDefinition: schemaDefinition,
         referenceLanguage: referenceLanguage,
         htmlContent: htmlContent,
         cssContent: cssContent,
         referenceStringifiedPayloadJson: referenceStringifiedPayloadJson,
       );

  /// Returns a shallow copy of this [DeployReadyTemplateState]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  DeployReadyTemplateState copyWith({
    _i3.PdfContent? pdfContent,
    _i4.SchemaDefinition? schemaDefinition,
    _i5.SupportedLanguages? referenceLanguage,
    String? htmlContent,
    String? cssContent,
    String? referenceStringifiedPayloadJson,
  }) {
    return DeployReadyTemplateState(
      pdfContent: pdfContent ?? this.pdfContent.copyWith(),
      schemaDefinition: schemaDefinition ?? this.schemaDefinition.copyWith(),
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      htmlContent: htmlContent ?? this.htmlContent,
      cssContent: cssContent ?? this.cssContent,
      referenceStringifiedPayloadJson:
          referenceStringifiedPayloadJson ??
          this.referenceStringifiedPayloadJson,
    );
  }
}

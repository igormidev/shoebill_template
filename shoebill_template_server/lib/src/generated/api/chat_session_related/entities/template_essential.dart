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
import '../../../api/pdf_related/entities/pdf_content.dart' as _i2;
import '../../../api/pdf_related/entities/schema_definition.dart' as _i3;
import '../../../entities/others/supported_languages.dart' as _i4;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i5;

abstract class TemplateEssential
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TemplateEssential._({
    required this.pdfContent,
    required this.schemaDefinition,
    required this.suggestedPrompt,
    required this.referenceLanguage,
  });

  factory TemplateEssential({
    required _i2.PdfContent pdfContent,
    required _i3.SchemaDefinition schemaDefinition,
    required String suggestedPrompt,
    required _i4.SupportedLanguages referenceLanguage,
  }) = _TemplateEssentialImpl;

  factory TemplateEssential.fromJson(Map<String, dynamic> jsonSerialization) {
    return TemplateEssential(
      pdfContent: _i5.Protocol().deserialize<_i2.PdfContent>(
        jsonSerialization['pdfContent'],
      ),
      schemaDefinition: _i5.Protocol().deserialize<_i3.SchemaDefinition>(
        jsonSerialization['schemaDefinition'],
      ),
      suggestedPrompt: jsonSerialization['suggestedPrompt'] as String,
      referenceLanguage: _i4.SupportedLanguages.fromJson(
        (jsonSerialization['referenceLanguage'] as String),
      ),
    );
  }

  _i2.PdfContent pdfContent;

  _i3.SchemaDefinition schemaDefinition;

  String suggestedPrompt;

  _i4.SupportedLanguages referenceLanguage;

  /// Returns a shallow copy of this [TemplateEssential]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TemplateEssential copyWith({
    _i2.PdfContent? pdfContent,
    _i3.SchemaDefinition? schemaDefinition,
    String? suggestedPrompt,
    _i4.SupportedLanguages? referenceLanguage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TemplateEssential',
      'pdfContent': pdfContent.toJson(),
      'schemaDefinition': schemaDefinition.toJson(),
      'suggestedPrompt': suggestedPrompt,
      'referenceLanguage': referenceLanguage.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TemplateEssential',
      'pdfContent': pdfContent.toJsonForProtocol(),
      'schemaDefinition': schemaDefinition.toJsonForProtocol(),
      'suggestedPrompt': suggestedPrompt,
      'referenceLanguage': referenceLanguage.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TemplateEssentialImpl extends TemplateEssential {
  _TemplateEssentialImpl({
    required _i2.PdfContent pdfContent,
    required _i3.SchemaDefinition schemaDefinition,
    required String suggestedPrompt,
    required _i4.SupportedLanguages referenceLanguage,
  }) : super._(
         pdfContent: pdfContent,
         schemaDefinition: schemaDefinition,
         suggestedPrompt: suggestedPrompt,
         referenceLanguage: referenceLanguage,
       );

  /// Returns a shallow copy of this [TemplateEssential]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TemplateEssential copyWith({
    _i2.PdfContent? pdfContent,
    _i3.SchemaDefinition? schemaDefinition,
    String? suggestedPrompt,
    _i4.SupportedLanguages? referenceLanguage,
  }) {
    return TemplateEssential(
      pdfContent: pdfContent ?? this.pdfContent.copyWith(),
      schemaDefinition: schemaDefinition ?? this.schemaDefinition.copyWith(),
      suggestedPrompt: suggestedPrompt ?? this.suggestedPrompt,
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
    );
  }
}

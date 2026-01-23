import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

/// Controller responsible for managing template scaffolds, versions, baselines,
/// and baseline implementations.
///
/// This controller provides methods to:
/// - Create new template scaffolds with their full entity hierarchy
/// - Add language translations to existing baselines
/// - Update template versions (UI-only changes to HTML/CSS)
/// - Create new template versions (when the schema changes)
class PdfController {
  /// Adds a new language implementation to an existing baseline by translating
  /// the reference implementation payload to the target language.
  ///
  /// Looks up the baseline by [baselineId], retrieves the associated version
  /// and schema, finds the reference implementation (in the baseline's
  /// reference language), translates all translatable strings using
  /// [SchemaDefinition.translateBasedOnSchema], and persists the new
  /// [ShoebillTemplateBaselineImplementation].
  ///
  /// Throws [ShoebillException] if:
  /// - The baseline is not found
  /// - The associated version or schema cannot be loaded
  /// - A translation for [targetLanguage] already exists on this baseline
  /// - The reference implementation is missing
  /// - The translation process fails
  Future<ShoebillTemplateBaselineImplementation> addNewLanguageToBaseline({
    required Session session,
    required UuidValue baselineId,
    required SupportedLanguages targetLanguage,
  }) async {
    final baseline = await ShoebillTemplateBaseline.db.findById(
      session,
      baselineId,
      include: ShoebillTemplateBaseline.include(
        version: ShoebillTemplateVersion.include(
          schema: SchemaDefinition.include(),
        ),
      ),
    );
    if (baseline == null) {
      throw ShoebillException(
        title: 'Baseline not found',
        description:
            'No ShoebillTemplateBaseline found for the provided ID: $baselineId',
      );
    }

    final version = baseline.version;
    if (version == null) {
      throw ShoebillException(
        title: 'Version not found',
        description:
            'No ShoebillTemplateVersion associated with baseline ID: $baselineId',
      );
    }

    final SchemaDefinition? schema = version.schema;
    if (schema == null) {
      throw ShoebillException(
        title: 'SchemaDefinition not found',
        description:
            'No SchemaDefinition found for the version associated with baseline ID: $baselineId',
      );
    }

    // Check if a translation for this language already exists on this baseline
    final alreadyExists =
        (await ShoebillTemplateBaselineImplementation.db.count(
          session,
          where: (t) =>
              t.baselineId.equals(baselineId) &
              t.language.equals(targetLanguage),
        )) >
        0;
    if (alreadyExists) {
      throw ShoebillException(
        title: 'Implementation already exists',
        description:
            'A BaselineImplementation for language "${targetLanguage.name}" '
            'already exists on baseline: $baselineId',
      );
    }

    // Find the reference implementation (the one in the baseline's reference language)
    final ShoebillTemplateBaselineImplementation? referenceImplementation =
        await ShoebillTemplateBaselineImplementation.db.findFirstRow(
          session,
          where: (t) =>
              t.baselineId.equals(baselineId) &
              t.language.equals(baseline.referenceLanguage),
        );
    if (referenceImplementation == null) {
      throw ShoebillException(
        title: 'Reference implementation not found',
        description:
            'No reference BaselineImplementation found for baseline ID: $baselineId '
            'and reference language: ${baseline.referenceLanguage.name}',
      );
    }

    // Translate the payload based on schema-defined translatable fields
    final String translatedPayload;
    try {
      translatedPayload = await schema.translateBasedOnSchema(
        stringifiedJson: referenceImplementation.stringifiedPayload,
        sourceLanguage: baseline.referenceLanguage,
        targetLanguage: targetLanguage,
      );
    } on ShoebillException catch (_) {
      rethrow;
    } catch (e) {
      throw ShoebillException(
        title: 'Translation failed',
        description:
            'An error occurred while translating the baseline implementation:\n$e',
      );
    }

    // Insert the new implementation and attach it to the baseline within a transaction
    return session.db.transaction((tx) async {
      final implementation =
          await ShoebillTemplateBaselineImplementation.db.insertRow(
        session,
        ShoebillTemplateBaselineImplementation(
          stringifiedPayload: translatedPayload,
          baselineId: baselineId,
          language: targetLanguage,
        ),
        transaction: tx,
      );

      await ShoebillTemplateBaseline.db.attachRow.implementations(
        session,
        baseline,
        implementation,
        transaction: tx,
      );

      return implementation;
    });
  }

  /// Creates a new template scaffold with the complete entity hierarchy:
  /// Scaffold -> Version -> VersionInput (HTML/CSS) -> Baseline -> BaselineImplementation
  ///
  /// This is the entry point for creating a brand new template from scratch.
  ///
  /// Parameters:
  /// - [pdfContent]: The metadata (name/description) for identifying this template
  /// - [schemaDefinition]: The schema that validates payloads for this template
  /// - [language]: The initial/reference language for the first baseline implementation
  /// - [stringifiedPayload]: A JSON payload conforming to the schema, used as the first implementation
  /// - [htmlContent]: The Jinja2 HTML template content
  /// - [cssContent]: The CSS styling content for the template
  ///
  /// Throws [ShoebillException] if:
  /// - The [stringifiedPayload] is not valid JSON
  /// - The payload does not conform to the schema
  /// - The [schemaDefinition] already has an ID (must be new)
  /// - The [pdfContent] already has an ID (must be new)
  Future<ShoebillTemplateScaffold> createNewTemplateScaffold({
    required Session session,
    required PdfContent pdfContent,
    required SchemaDefinition schemaDefinition,
    required SupportedLanguages language,
    required String stringifiedPayload,
    required String htmlContent,
    required String cssContent,
  }) async {
    final Map<String, dynamic>? payload = tryDecode(stringifiedPayload);
    if (payload == null) {
      throw ShoebillException(
        title: 'Invalid JSON',
        description: 'Provided stringifiedPayload is not valid JSON.',
      );
    }

    final error = schemaDefinition.validateJsonFollowsSchemaStructure(payload);
    if (error != null) {
      throw ShoebillException(
        title: 'Payload does not conform to schema',
        description: error,
      );
    }
    if (schemaDefinition.id != null) {
      throw ShoebillException(
        title: 'SchemaDefinition already exists',
        description:
            'SchemaDefinition should not have an ID when creating a new template scaffold.',
      );
    }
    if (pdfContent.id != null) {
      throw ShoebillException(
        title: 'PdfContent already exists',
        description:
            'PdfContent should not have an ID when creating a new template scaffold.',
      );
    }

    return session.db.transaction((tx) async {
      // 1. Insert PdfContent (template metadata: name, description)
      pdfContent = await PdfContent.db.insertRow(
        session,
        pdfContent,
        transaction: tx,
      );

      // 2. Insert SchemaDefinition
      schemaDefinition = await SchemaDefinition.db.insertRow(
        session,
        schemaDefinition,
        transaction: tx,
      );

      // 3. Insert ShoebillTemplateVersionInput (HTML/CSS content)
      final versionInput = await ShoebillTemplateVersionInput.db.insertRow(
        session,
        ShoebillTemplateVersionInput(
          htmlContent: htmlContent,
          cssContent: cssContent,
        ),
        transaction: tx,
      );

      // 4. Insert ShoebillTemplateScaffold
      final scaffold = await ShoebillTemplateScaffold.db.insertRow(
        session,
        ShoebillTemplateScaffold(
          referencePdfContentId: pdfContent.id!,
          referencePdfContent: pdfContent,
        ),
        transaction: tx,
      );

      // 5. Insert ShoebillTemplateVersion linking schema, input, and scaffold
      final version = await ShoebillTemplateVersion.db.insertRow(
        session,
        ShoebillTemplateVersion(
          schemaId: schemaDefinition.id!,
          schema: schemaDefinition,
          inputId: versionInput.id!,
          input: versionInput,
          scaffoldId: scaffold.id,
        ),
        transaction: tx,
      );

      // 6. Insert ShoebillTemplateBaseline
      final baseline = await ShoebillTemplateBaseline.db.insertRow(
        session,
        ShoebillTemplateBaseline(
          referenceLanguage: language,
          versionId: version.id!,
          version: version,
        ),
        transaction: tx,
      );

      // 7. Insert ShoebillTemplateBaselineImplementation
      final implementation =
          await ShoebillTemplateBaselineImplementation.db.insertRow(
        session,
        ShoebillTemplateBaselineImplementation(
          stringifiedPayload: stringifiedPayload,
          language: language,
          baselineId: baseline.id,
        ),
        transaction: tx,
      );

      // 8. Attach the implementation to the baseline
      await ShoebillTemplateBaseline.db.attachRow.implementations(
        session,
        baseline,
        implementation,
        transaction: tx,
      );

      return scaffold;
    });
  }

  /// Updates the HTML/CSS content of an existing template version.
  ///
  /// This is used when the user makes UI-only changes (e.g., background color,
  /// layout adjustments) that do NOT affect the schema. Since the schema remains
  /// unchanged, existing baselines and implementations continue to work correctly.
  /// Rendered PDFs will reflect the updated UI the next time they are generated.
  ///
  /// Parameters:
  /// - [versionId]: The ID of the [ShoebillTemplateVersion] whose input to update
  /// - [htmlContent]: The updated Jinja2 HTML template content
  /// - [cssContent]: The updated CSS styling content
  ///
  /// Throws [ShoebillException] if:
  /// - The version is not found
  /// - The associated [ShoebillTemplateVersionInput] is not found
  Future<ShoebillTemplateVersionInput> updateTemplateVersion({
    required Session session,
    required int versionId,
    required String htmlContent,
    required String cssContent,
  }) async {
    final version = await ShoebillTemplateVersion.db.findById(
      session,
      versionId,
      include: ShoebillTemplateVersion.include(
        input: ShoebillTemplateVersionInput.include(),
      ),
    );
    if (version == null) {
      throw ShoebillException(
        title: 'Version not found',
        description:
            'No ShoebillTemplateVersion found for the provided ID: $versionId',
      );
    }

    final existingInput = version.input;
    if (existingInput == null) {
      throw ShoebillException(
        title: 'VersionInput not found',
        description:
            'No ShoebillTemplateVersionInput found for version ID: $versionId',
      );
    }

    // Update the existing input with new HTML/CSS content
    final updatedInput = existingInput.copyWith(
      htmlContent: htmlContent,
      cssContent: cssContent,
    );

    return ShoebillTemplateVersionInput.db.updateRow(
      session,
      updatedInput,
    );
  }

  /// Creates a new template version under an existing scaffold when the schema
  /// has changed.
  ///
  /// When a user modifies the schema (e.g., adds/removes fields), a new version
  /// must be created because old implementations may reference variables that
  /// no longer exist or miss newly required ones. The previous version remains
  /// intact so that baselines created under it continue to render correctly.
  ///
  /// Parameters:
  /// - [scaffoldId]: The UUID of the parent [ShoebillTemplateScaffold]
  /// - [schemaDefinition]: The new schema for this version (must not have an ID)
  /// - [htmlContent]: The Jinja2 HTML template content for the new version
  /// - [cssContent]: The CSS styling content for the new version
  ///
  /// Returns the newly created [ShoebillTemplateVersion].
  ///
  /// Throws [ShoebillException] if:
  /// - The scaffold is not found
  /// - The [schemaDefinition] already has an ID (must be new)
  Future<ShoebillTemplateVersion> createNewTemplateVersion({
    required Session session,
    required UuidValue scaffoldId,
    required SchemaDefinition schemaDefinition,
    required String htmlContent,
    required String cssContent,
  }) async {
    final scaffold = await ShoebillTemplateScaffold.db.findById(
      session,
      scaffoldId,
    );
    if (scaffold == null) {
      throw ShoebillException(
        title: 'Scaffold not found',
        description:
            'No ShoebillTemplateScaffold found for the provided ID: $scaffoldId',
      );
    }

    if (schemaDefinition.id != null) {
      throw ShoebillException(
        title: 'SchemaDefinition already exists',
        description:
            'SchemaDefinition should not have an ID when creating a new template version.',
      );
    }

    return session.db.transaction((tx) async {
      // 1. Insert the new SchemaDefinition
      schemaDefinition = await SchemaDefinition.db.insertRow(
        session,
        schemaDefinition,
        transaction: tx,
      );

      // 2. Insert the new ShoebillTemplateVersionInput with HTML/CSS
      final versionInput = await ShoebillTemplateVersionInput.db.insertRow(
        session,
        ShoebillTemplateVersionInput(
          htmlContent: htmlContent,
          cssContent: cssContent,
        ),
        transaction: tx,
      );

      // 3. Insert the new ShoebillTemplateVersion linking to scaffold, schema, and input
      final version = await ShoebillTemplateVersion.db.insertRow(
        session,
        ShoebillTemplateVersion(
          schemaId: schemaDefinition.id!,
          schema: schemaDefinition,
          inputId: versionInput.id!,
          input: versionInput,
          scaffoldId: scaffoldId,
        ),
        transaction: tx,
      );

      // 4. Attach the new version to the scaffold
      await ShoebillTemplateScaffold.db.attachRow.versions(
        session,
        scaffold,
        version,
        transaction: tx,
      );

      return version;
    });
  }
}

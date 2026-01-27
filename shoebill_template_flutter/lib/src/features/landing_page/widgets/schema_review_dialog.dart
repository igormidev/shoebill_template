import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/src/core/shared_providers/serverpod_providers.dart';
import 'package:shoebill_template_flutter/src/design_system/default_error_snackbar.dart';

import '../../../../gen_l10n/s.dart';

/// A dialog that displays the generated schema for user review.
///
/// This dialog appears after the user uploads JSON and the AI generates
/// the template essentials. Users can review property types, toggle nullable
/// states, and view the suggested prompt.
///
/// Returns the session UUID when confirmed and chat session is started,
/// or null if cancelled.
class SchemaReviewDialog extends ConsumerStatefulWidget {
  const SchemaReviewDialog({
    super.key,
    required this.templateEssential,
    required this.stringifiedPayload,
  });

  /// The template essential containing the schema and suggested prompt.
  final TemplateEssential templateEssential;

  /// The original stringified JSON payload.
  final String stringifiedPayload;

  /// Shows the schema review dialog and returns the session UUID if confirmed.
  ///
  /// Returns null if the user cancels or dismisses the dialog.
  static Future<String?> show({
    required BuildContext context,
    required TemplateEssential templateEssential,
    required String stringifiedPayload,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SchemaReviewDialog(
        templateEssential: templateEssential,
        stringifiedPayload: stringifiedPayload,
      ),
    );
  }

  @override
  ConsumerState<SchemaReviewDialog> createState() => _SchemaReviewDialogState();
}

class _SchemaReviewDialogState extends ConsumerState<SchemaReviewDialog> {
  /// Local mutable copy of the properties map with nullable toggles.
  late Map<String, SchemaProperty> _properties;

  /// Whether the dialog is currently loading (starting chat session).
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the properties map
    _properties = Map<String, SchemaProperty>.from(
      widget.templateEssential.schemaDefinition.properties,
    );
  }

  void _toggleNullable(String propertyName) {
    final property = _properties[propertyName];
    if (property == null) return;

    setState(() {
      _properties[propertyName] = property.copyWith(
        nullable: !property.nullable,
      );
    });
  }

  Future<void> _onConfirm() async {
    setState(() => _isLoading = true);

    try {
      final client = ref.read(clientProvider);

      // Create the modified schema
      final modifiedSchema = SchemaDefinition(
        id: widget.templateEssential.schemaDefinition.id,
        properties: _properties,
      );

      // Create the NewTemplateState to start a chat session
      final newTemplateState = NewTemplateState(
        pdfContent: widget.templateEssential.pdfContent,
        schemaDefinition: modifiedSchema,
        referenceLanguage: widget.templateEssential.referenceLanguage,
        referenceStringifiedPayloadJson: widget.stringifiedPayload,
      );

      // Start the chat session
      final sessionUUID = await client.chatSession.startChatFromNewTemplate(
        newTemplateState: newTemplateState,
      );

      if (mounted) {
        Navigator.of(context).pop(sessionUUID);
      }
    } on ShoebillException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        await handleBabelException(context, e);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        await handleBabelException(context, null);
      }
    }
  }

  void _onCancel() {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(l10n, colorScheme),
              const SizedBox(height: 8),
              Text(
                l10n.schema_review_instructions,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Flexible(
                child: _buildContent(l10n, theme, colorScheme),
              ),
              const SizedBox(height: 24),
              _buildActions(l10n, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(S l10n, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(
          Icons.schema_outlined,
          size: 28,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          l10n.schema_review_title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(S l10n, ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Schema properties section
          _buildPropertiesSection(l10n, theme, colorScheme),
          const SizedBox(height: 24),
          // Suggested prompt section
          _buildSuggestedPromptSection(l10n, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildPropertiesSection(
    S l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (_properties.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            l10n.schema_no_fields,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  l10n.schema_field_name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  l10n.schema_field_type,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  l10n.schema_nullable,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Property rows
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            children: _properties.entries.map((entry) {
              final isLast = entry.key == _properties.keys.last;
              return _buildPropertyRow(
                entry.key,
                entry.value,
                l10n,
                theme,
                colorScheme,
                isLast: isLast,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyRow(
    String name,
    SchemaProperty property,
    S l10n,
    ThemeData theme,
    ColorScheme colorScheme, {
    bool isLast = false,
  }) {
    final typeInfo = _getTypeInfo(property, l10n, colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Property name
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (property.description != null &&
                        property.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        property.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Property type with icon
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      typeInfo.icon,
                      size: 18,
                      color: typeInfo.color,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        typeInfo.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: typeInfo.color,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Nullable toggle
              SizedBox(
                width: 100,
                child: Center(
                  child: Switch(
                    value: property.nullable,
                    onChanged: (_) => _toggleNullable(name),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedPromptSection(
    S l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 20,
              color: colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.schema_suggested_prompt,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.schema_suggested_prompt_hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Text(
            widget.templateEssential.suggestedPrompt,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(S l10n, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: _isLoading ? null : _onCancel,
          child: Text(l10n.schema_edit),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: _isLoading ? null : _onConfirm,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.schema_confirm),
        ),
      ],
    );
  }

  _TypeInfo _getTypeInfo(SchemaProperty property, S l10n, ColorScheme colors) {
    return switch (property) {
      SchemaPropertyString() => _TypeInfo(
          label: l10n.schema_type_string,
          icon: Icons.text_fields,
          color: colors.primary,
        ),
      SchemaPropertyInteger() => _TypeInfo(
          label: l10n.schema_type_integer,
          icon: Icons.numbers,
          color: colors.tertiary,
        ),
      SchemaPropertyDouble() => _TypeInfo(
          label: l10n.schema_type_double,
          icon: Icons.percent,
          color: colors.tertiary,
        ),
      SchemaPropertyBoolean() => _TypeInfo(
          label: l10n.schema_type_boolean,
          icon: Icons.toggle_on_outlined,
          color: colors.error,
        ),
      SchemaPropertyArray() => _TypeInfo(
          label: l10n.schema_type_array,
          icon: Icons.list,
          color: colors.secondary,
        ),
      SchemaPropertyEnum() => _TypeInfo(
          label: l10n.schema_type_enum,
          icon: Icons.format_list_bulleted,
          color: Colors.orange,
        ),
      SchemaPropertyStructuredObjectWithDefinedProperties() => _TypeInfo(
          label: l10n.schema_type_object,
          icon: Icons.data_object,
          color: Colors.purple,
        ),
      SchemaPropertyObjectWithUndefinedProperties() => _TypeInfo(
          label: l10n.schema_type_object,
          icon: Icons.data_object,
          color: Colors.purple,
        ),
    };
  }
}

/// Helper class to hold type display information.
class _TypeInfo {
  const _TypeInfo({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

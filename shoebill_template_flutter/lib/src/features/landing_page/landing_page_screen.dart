import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/gen_l10n/s.dart';
import 'package:shoebill_template_flutter/src/core/shared_providers/go_router_providers.dart';
import 'package:shoebill_template_flutter/src/core/shared_providers/serverpod_providers.dart';
import 'package:shoebill_template_flutter/src/design_system/default_error_snackbar.dart';
import 'package:shoebill_template_flutter/src/features/landing_page/landing_page_providers.dart';
import 'package:shoebill_template_flutter/src/features/landing_page/widgets/json_drop_zone.dart';
import 'package:shoebill_template_flutter/src/features/landing_page/widgets/json_paste_dialog.dart';
import 'package:shoebill_template_flutter/src/features/landing_page/widgets/logo_placeholder.dart';
import 'package:shoebill_template_flutter/src/features/landing_page/widgets/schema_review_dialog.dart';
import 'package:shoebill_template_flutter/src/responsive/breakpoints.dart';

/// Landing page screen for the Shoebill Template app.
/// Allows users to upload JSON files via drag-and-drop, paste, or file picker.
class LandingPageScreen extends ConsumerStatefulWidget {
  const LandingPageScreen({super.key});

  @override
  ConsumerState<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends ConsumerState<LandingPageScreen> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final theme = Theme.of(context);
    final landingState = ref.watch(landingPageStateProvider);

    return Scaffold(
      body: DropTarget(
        onDragEntered: (_) => setState(() => _isDragging = true),
        onDragExited: (_) => setState(() => _isDragging = false),
        onDragDone: (details) {
          setState(() => _isDragging = false);
          _handleFileDrop(details.files);
        },
        child: Stack(
          children: [
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isExpanded = constraints.maxWidth >= Breakpoints.expanded;

                  if (isExpanded) {
                    return _buildExpandedLayout(context, l10n, theme);
                  } else {
                    return _buildCompactLayout(context, l10n, theme);
                  }
                },
              ),
            ),
            // Loading overlay
            if (landingState.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            landingState.thinkingText ?? l10n.loading,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            // Drag overlay
            if (_isDragging)
              Container(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.file_download,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.landing_drop_files,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedLayout(BuildContext context, S l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - content
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(l10n, theme),
                const SizedBox(height: 48),
                Expanded(
                  child: _buildDropZone(l10n, theme),
                ),
                const SizedBox(height: 24),
                _buildActionButtons(l10n, theme),
              ],
            ),
          ),
          const SizedBox(width: 64),
          // Right side - logo
          Expanded(
            flex: 2,
            child: Center(
              child: LogoPlaceholder(size: 280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLayout(BuildContext context, S l10n, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(l10n, theme),
          const SizedBox(height: 32),
          Center(child: LogoPlaceholder(size: 160)),
          const SizedBox(height: 32),
          SizedBox(
            height: 300,
            child: _buildDropZone(l10n, theme),
          ),
          const SizedBox(height: 24),
          _buildActionButtons(l10n, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(S l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.landing_headline,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.landing_subtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildDropZone(S l10n, ThemeData theme) {
    return JsonDropZone(
      onFileDrop: _handleFileDrop,
      isDragging: _isDragging,
    );
  }

  Widget _buildActionButtons(S l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: _showPasteDialog,
          icon: const Icon(Icons.content_paste),
          label: Text(l10n.landing_paste_json),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _pickJsonFile,
          icon: const Icon(Icons.folder_open),
          label: Text(l10n.landing_browse_files),
        ),
      ],
    );
  }

  Future<void> _handleFileDrop(List<XFile> files) async {
    if (files.isEmpty) return;

    final file = files.first;
    final extension = file.name.split('.').last.toLowerCase();

    if (extension != 'json') {
      if (mounted) {
        await handleBabelException(
          context,
          ShoebillException(
            title: 'Invalid File',
            description: S.of(context)!.landing_invalid_json,
          ),
        );
      }
      return;
    }

    try {
      final content = await file.readAsString();
      await _processJsonContent(content);
    } catch (e) {
      if (mounted) {
        await handleBabelException(
          context,
          ShoebillException(
            title: 'Error',
            description: S.of(context)!.landing_invalid_json,
          ),
        );
      }
    }
  }

  Future<void> _showPasteDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const JsonPasteDialog(),
    );

    if (result != null && result.isNotEmpty) {
      await _processJsonContent(result);
    }
  }

  Future<void> _pickJsonFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        String content;

        if (file.bytes != null) {
          content = utf8.decode(file.bytes!);
        } else if (file.path != null) {
          final xFile = XFile(file.path!);
          content = await xFile.readAsString();
        } else {
          throw Exception('Unable to read file');
        }

        await _processJsonContent(content);
      }
    } catch (e) {
      if (mounted) {
        await handleBabelException(
          context,
          ShoebillException(
            title: 'Error',
            description: S.of(context)!.landing_invalid_json,
          ),
        );
      }
    }
  }

  Future<void> _processJsonContent(String content) async {
    // Validate JSON first
    if (!_isValidJson(content)) {
      if (mounted) {
        await handleBabelException(
          context,
          ShoebillException(
            title: 'Invalid JSON',
            description: S.of(context)!.landing_invalid_json,
          ),
        );
      }
      return;
    }

    // Call the createTemplateEssentials endpoint
    final client = ref.read(clientProvider);
    final notifier = ref.read(landingPageStateProvider.notifier);

    notifier.setLoading(true);
    notifier.setThinkingText(S.of(context)!.chat_thinking);

    try {
      TemplateEssential? templateEssential;

      await for (final result in client.createTemplateEssentials.call(
        stringifiedPayload: content,
      )) {
        if (result is TemplateEssentialThinkingResult) {
          notifier.setThinkingText(result.thinkingChunk.thinkingText);
        } else if (result is TemplateEssentialFinalResult) {
          templateEssential = result.template;
        }
      }

      notifier.setLoading(false);

      if (templateEssential != null && mounted) {
        // Show the schema review dialog
        final sessionUUID = await SchemaReviewDialog.show(
          context: context,
          templateEssential: templateEssential,
          stringifiedPayload: content,
        );

        if (sessionUUID != null && mounted) {
          // Navigate to chat screen with the session UUID
          context.go(AppRoutes.chatPath(sessionUUID));
        }
      }
    } on ShoebillException catch (e) {
      notifier.setLoading(false);
      if (mounted) {
        await handleBabelException(context, e);
      }
    } catch (e) {
      notifier.setLoading(false);
      if (mounted) {
        await handleBabelException(context, null);
      }
    }
  }

  bool _isValidJson(String content) {
    try {
      json.decode(content);
      return true;
    } catch (e) {
      return false;
    }
  }
}

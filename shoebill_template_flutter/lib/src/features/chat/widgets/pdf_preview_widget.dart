import 'package:flutter/material.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/gen_l10n/s.dart';

/// A reusable widget that displays the PDF preview area.
/// Shows placeholder when no template is ready, or renders the PDF preview
/// when HTML/CSS content is available.
class PdfPreviewWidget extends StatefulWidget {
  final TemplateCurrentState? templateState;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const PdfPreviewWidget({
    super.key,
    this.templateState,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  State<PdfPreviewWidget> createState() => _PdfPreviewWidgetState();
}

class _PdfPreviewWidgetState extends State<PdfPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Main content
          _buildContent(context, theme, l10n),

          // Refresh button
          if (widget.templateState is DeployReadyTemplateState)
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: widget.isLoading ? null : widget.onRefresh,
                icon: const Icon(Icons.refresh),
                tooltip: l10n?.refreshing ?? 'Refresh',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),

          // Loading overlay
          if (widget.isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.loading ?? 'Loading...',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, S? l10n) {
    final templateState = widget.templateState;

    if (templateState == null) {
      return _buildPlaceholder(theme, l10n);
    }

    if (templateState is DeployReadyTemplateState) {
      return _buildPdfPreview(context, theme, templateState);
    }

    // NewTemplateState - show waiting for AI message
    return _buildWaitingForAI(theme, l10n);
  }

  Widget _buildPlaceholder(ThemeData theme, S? l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'PDF EXAMPLE IN REAL TIME',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '(most recent version of it)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingForAI(ThemeData theme, S? l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Waiting for AI to generate template...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation to build your PDF template',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPdfPreview(
    BuildContext context,
    ThemeData theme,
    DeployReadyTemplateState templateState,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.picture_as_pdf,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  templateState.pdfContent.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (templateState.pdfContent.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              templateState.pdfContent.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // PDF Preview Content Area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildHtmlPreview(context, theme, templateState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlPreview(
    BuildContext context,
    ThemeData theme,
    DeployReadyTemplateState templateState,
  ) {
    // For now, show a simplified preview indication
    // In a production app, you would use a WebView or render the HTML
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.preview,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Template Ready',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ready to Deploy',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Show template info
            _buildTemplateInfo(theme, templateState),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateInfo(ThemeData theme, DeployReadyTemplateState templateState) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            theme,
            'Language',
            templateState.referenceLanguage.name.toUpperCase(),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            theme,
            'Schema Fields',
            '${templateState.schemaDefinition.properties.length}',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            theme,
            'HTML',
            '${templateState.htmlContent.length} chars',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            theme,
            'CSS',
            '${templateState.cssContent.length} chars',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

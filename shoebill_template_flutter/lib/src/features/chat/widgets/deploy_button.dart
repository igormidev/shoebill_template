import 'package:flutter/material.dart';
import 'package:shoebill_template_flutter/gen_l10n/s.dart';

/// A deploy button that shows in the app bar
class DeployButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDeploying;
  final bool canDeploy;

  const DeployButton({
    super.key,
    required this.onPressed,
    this.isDeploying = false,
    this.canDeploy = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    if (isDeploying) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Deploying...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return FilledButton.icon(
      onPressed: canDeploy ? onPressed : null,
      icon: const Icon(Icons.cloud_upload, size: 18),
      label: Text(l10n?.chat_deploy ?? 'Deploy'),
      style: FilledButton.styleFrom(
        backgroundColor: canDeploy
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withValues(alpha: 0.3),
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

/// A confirmation dialog for deployment
class DeployConfirmationDialog extends StatelessWidget {
  final String templateName;

  const DeployConfirmationDialog({
    super.key,
    required this.templateName,
  });

  static Future<bool> show(BuildContext context, {required String templateName}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeployConfirmationDialog(templateName: templateName),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return AlertDialog(
      title: Text(l10n?.chat_deploy_template ?? 'Deploy Template'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to deploy this template?',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    templateName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This will make the template available for use.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n?.button_cancel ?? 'Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.cloud_upload, size: 18),
          label: Text(l10n?.chat_deploy ?? 'Deploy'),
        ),
      ],
    );
  }
}

/// A success dialog shown after successful deployment
class DeploySuccessDialog extends StatelessWidget {
  final VoidCallback? onDismiss;

  const DeploySuccessDialog({
    super.key,
    this.onDismiss,
  });

  static Future<void> show(BuildContext context, {VoidCallback? onDismiss}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeploySuccessDialog(onDismiss: onDismiss),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return AlertDialog(
      icon: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 48,
      ),
      title: Text(l10n?.chat_success_deployed ?? 'Template deployed successfully!'),
      content: Text(
        'Your template is now ready to use.',
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss?.call();
          },
          child: Text(l10n?.button_ok ?? 'OK'),
        ),
      ],
    );
  }
}

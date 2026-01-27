import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shoebill_template_flutter/src/core/shared_providers/serverpod_providers.dart';
import 'package:shoebill_template_flutter/src/features/auth/account_provider.dart';

/// A dialog that shows the authentication flow for creating or logging into an account.
///
/// This dialog wraps the Serverpod EmailSignInWidget and handles the
/// account creation/linking flow after successful authentication.
class AuthDialog extends ConsumerStatefulWidget {
  /// Optional scaffold ID to link to the account after authentication.
  final UuidValue? scaffoldIdToLink;

  /// Title shown in the dialog header.
  final String? title;

  /// Message shown above the auth form.
  final String? message;

  const AuthDialog({
    super.key,
    this.scaffoldIdToLink,
    this.title,
    this.message,
  });

  /// Shows the auth dialog and returns true if authentication was successful.
  static Future<bool> show(
    BuildContext context, {
    UuidValue? scaffoldIdToLink,
    String? title,
    String? message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthDialog(
        scaffoldIdToLink: scaffoldIdToLink,
        title: title,
        message: message,
      ),
    );
    return result ?? false;
  }

  @override
  ConsumerState<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends ConsumerState<AuthDialog> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set the scaffold to be attached after authentication
    if (widget.scaffoldIdToLink != null) {
      ref.read(accountProvider.notifier).setScaffoldToAttach(widget.scaffoldIdToLink!);
    }
  }

  Future<void> _onAuthenticated() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch/create account info (will also attach the scaffold if set)
      await ref.read(accountProvider.notifier).getAccountInfo(force: true);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete account setup: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onError(Object error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication error: $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final client = ref.watch(clientProvider);

    final title = widget.title ?? 'Create Account';
    final message = widget.message ??
        'Create an account to save your templates and access them from any device.';

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 450,
          maxHeight: 650,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              centerTitle: true,
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Message section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  message,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Auth form
                      Expanded(
                        child: EmailSignInWidget(
                          client: client,
                          startScreen: EmailFlowScreen.startRegistration,
                          onAuthenticated: _onAuthenticated,
                          onError: _onError,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// A simpler login/signup button that opens the auth dialog.
class AuthButton extends ConsumerWidget {
  /// Optional scaffold ID to link after authentication.
  final UuidValue? scaffoldIdToLink;

  /// Callback after successful authentication.
  final VoidCallback? onAuthenticated;

  /// The button label.
  final String? label;

  const AuthButton({
    super.key,
    this.scaffoldIdToLink,
    this.onAuthenticated,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      onPressed: () async {
        final success = await AuthDialog.show(
          context,
          scaffoldIdToLink: scaffoldIdToLink,
        );
        if (success) {
          onAuthenticated?.call();
        }
      },
      icon: const Icon(Icons.person_add),
      label: Text(label ?? 'Sign In'),
    );
  }
}

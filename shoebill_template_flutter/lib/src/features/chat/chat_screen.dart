import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/gen_l10n/s.dart';
import 'package:shoebill_template_flutter/src/features/auth/account_provider.dart';
import 'package:shoebill_template_flutter/src/features/auth/auth_dialog.dart';
import 'package:shoebill_template_flutter/src/features/chat/chat_providers.dart';
import 'package:shoebill_template_flutter/src/features/chat/widgets/chat_input_field.dart';
import 'package:shoebill_template_flutter/src/features/chat/widgets/chat_message_list.dart';
import 'package:shoebill_template_flutter/src/features/chat/widgets/deploy_button.dart';
import 'package:shoebill_template_flutter/src/features/chat/widgets/pdf_preview_widget.dart';
import 'package:shoebill_template_flutter/src/responsive/breakpoints.dart';

/// The main chat screen with split layout for PDF preview and chat interface.
///
/// On desktop (expanded), shows a 60/40 split between PDF preview and chat.
/// On mobile (compact), uses a tabbed interface.
///
/// The screen can be initialized in two ways:
/// 1. With a [sessionId] - for navigation from landing page or deep linking
/// 2. With [newTemplateState] or [existingTemplateVersionId] - for direct initialization
class ChatScreen extends ConsumerStatefulWidget {
  /// The session UUID for an existing chat session (used for navigation/deep linking)
  final String? sessionId;

  /// The initial template state for a new template session
  final NewTemplateState? newTemplateState;

  /// The version ID for an existing template session
  final int? existingTemplateVersionId;

  /// Callback when navigation back is requested
  final VoidCallback? onBack;

  /// Callback when deployment is successful
  final void Function(UuidValue scaffoldId)? onDeploySuccess;

  const ChatScreen({
    super.key,
    this.sessionId,
    this.newTemplateState,
    this.existingTemplateVersionId,
    this.onBack,
    this.onDeploySuccess,
  }) : assert(
         sessionId != null || newTemplateState != null || existingTemplateVersionId != null,
         'Either sessionId, newTemplateState, or existingTemplateVersionId must be provided',
       );

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeSession();
      _isInitialized = true;
    }
  }

  Future<void> _initializeSession() async {
    final notifier = ref.read(chatProvider.notifier);

    if (widget.sessionId != null) {
      // Session already exists (from landing page or deep link)
      // Set the session UUID and attempt to resume/validate it
      await notifier.resumeSession(sessionUUID: widget.sessionId!);
    } else if (widget.newTemplateState != null) {
      await notifier.startNewTemplateSession(
        newTemplateState: widget.newTemplateState!,
      );
    } else if (widget.existingTemplateVersionId != null) {
      await notifier.startExistingTemplateSession(
        templateVersionId: widget.existingTemplateVersionId!,
      );
    }
  }

  Future<void> _handleSendMessage(String message) async {
    final notifier = ref.read(chatProvider.notifier);
    await notifier.sendMessage(message: message);
  }

  Future<void> _handleDeploy() async {
    final chatState = ref.read(chatProvider);
    final templateState = chatState.templateState;

    if (templateState is! DeployReadyTemplateState) return;

    final templateName = templateState.pdfContent.name;

    // Check if user is authenticated
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    if (!isAuthenticated) {
      // Show auth dialog before proceeding with deployment
      final authSuccess = await AuthDialog.show(
        context,
        title: 'Sign in to Deploy',
        message:
            'Create an account or sign in to deploy your template and save it to your account.',
      );

      if (!authSuccess || !mounted) return;
    }

    final confirmed = await DeployConfirmationDialog.show(
      context,
      templateName: templateName,
    );

    if (!confirmed || !mounted) return;

    final notifier = ref.read(chatProvider.notifier);
    final scaffoldId = await notifier.deployTemplate();

    if (scaffoldId != null) {
      // Link the deployed scaffold to the user's account
      final accountNotifier = ref.read(accountProvider.notifier);
      await accountNotifier.attachScaffold(scaffoldId);

      if (!mounted) return;
      await DeploySuccessDialog.show(
        context,
        onDismiss: () {
          widget.onDeploySuccess?.call(scaffoldId);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final isLoading = ref.watch(isLoadingProvider);
    final canDeploy = ref.watch(canDeployProvider);
    final isDeploying = ref.watch(isDeployingProvider);
    final templateState = ref.watch(templateStateProvider);

    // Show error snackbar when error occurs
    ref.listen<String?>(errorMessageProvider, (previous, next) {
      if (next != null && previous != next) {
        _showErrorSnackbar(context, next);
      }
    });

    return Scaffold(
      appBar: _buildAppBar(context, l10n, canDeploy, isDeploying, templateState),
      body: isLoading
          ? _buildLoadingState(context, l10n)
          : _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    S? l10n,
    bool canDeploy,
    bool isDeploying,
    TemplateCurrentState? templateState,
  ) {
    final isCompact = context.isCompact;

    String title = l10n?.app_title ?? 'Shoebill Template';
    if (templateState is DeployReadyTemplateState) {
      title = templateState.pdfContent.name;
    } else if (templateState is NewTemplateState) {
      title = templateState.pdfContent.name;
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: widget.onBack,
        tooltip: l10n?.chat_back_accessibility ?? 'Go back to previous screen',
      ),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        if (!isCompact)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DeployButton(
              onPressed: _handleDeploy,
              canDeploy: canDeploy,
              isDeploying: isDeploying,
            ),
          ),
      ],
      bottom: isCompact
          ? TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: const Icon(Icons.picture_as_pdf),
                  text: 'Preview',
                ),
                Tab(
                  icon: const Icon(Icons.chat),
                  text: 'Chat',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildLoadingState(BuildContext context, S? l10n) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            l10n?.loading ?? 'Loading...',
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final isCompact = context.isCompact;

    if (isCompact) {
      return _buildMobileLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final templateState = ref.watch(templateStateProvider);
    final messages = ref.watch(messagesProvider);
    final isSendingMessage = ref.watch(isSendingMessageProvider);
    final canSendMessage = ref.watch(canSendMessageProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // PDF Preview (60% width)
          Expanded(
            flex: 6,
            child: PdfPreviewWidget(
              templateState: templateState,
              isLoading: isSendingMessage,
            ),
          ),
          const SizedBox(width: 16),
          // Chat Interface (40% width)
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  child: ChatMessageList(
                    messages: messages,
                    isTyping: isSendingMessage,
                  ),
                ),
                ChatInputField(
                  onSend: _handleSendMessage,
                  enabled: canSendMessage,
                  isLoading: isSendingMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final l10n = S.of(context);
    final templateState = ref.watch(templateStateProvider);
    final messages = ref.watch(messagesProvider);
    final isSendingMessage = ref.watch(isSendingMessageProvider);
    final canSendMessage = ref.watch(canSendMessageProvider);
    final canDeploy = ref.watch(canDeployProvider);
    final isDeploying = ref.watch(isDeployingProvider);

    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Preview Tab
              Padding(
                padding: const EdgeInsets.all(16),
                child: PdfPreviewWidget(
                  templateState: templateState,
                  isLoading: isSendingMessage,
                ),
              ),
              // Chat Tab
              Column(
                children: [
                  Expanded(
                    child: ChatMessageList(
                      messages: messages,
                      isTyping: isSendingMessage,
                    ),
                  ),
                  ChatInputField(
                    onSend: _handleSendMessage,
                    enabled: canSendMessage,
                    isLoading: isSendingMessage,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Deploy button at bottom for mobile
        Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            top: 8,
          ),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: canDeploy ? _handleDeploy : null,
              icon: isDeploying
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(
                isDeploying
                    ? 'Deploying...'
                    : (l10n?.chat_deploy_template ?? 'Deploy Template'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

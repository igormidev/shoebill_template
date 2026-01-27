import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/src/core/shared_providers/serverpod_providers.dart';

/// State class that holds all chat-related data
class ChatState {
  final String? sessionUUID;
  final List<ChatMessage> messages;
  final TemplateCurrentState? templateState;
  final bool isLoading;
  final bool isSendingMessage;
  final bool isDeploying;
  final String? errorMessage;

  const ChatState({
    this.sessionUUID,
    this.messages = const [],
    this.templateState,
    this.isLoading = false,
    this.isSendingMessage = false,
    this.isDeploying = false,
    this.errorMessage,
  });

  /// Whether the template is ready for deployment
  bool get canDeploy =>
      templateState is DeployReadyTemplateState && !isDeploying && !isSendingMessage;

  /// Whether the user can send messages
  bool get canSendMessage => sessionUUID != null && !isSendingMessage && !isDeploying;

  ChatState copyWith({
    String? sessionUUID,
    List<ChatMessage>? messages,
    TemplateCurrentState? templateState,
    bool? isLoading,
    bool? isSendingMessage,
    bool? isDeploying,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      sessionUUID: sessionUUID ?? this.sessionUUID,
      messages: messages ?? this.messages,
      templateState: templateState ?? this.templateState,
      isLoading: isLoading ?? this.isLoading,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isDeploying: isDeploying ?? this.isDeploying,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier that manages the chat state using modern Riverpod 3 patterns
class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() {
    return const ChatState();
  }

  /// Get the client from the provider
  Client get _client => ref.read(clientProvider);

  /// Initialize a new chat session for a new template
  Future<void> startNewTemplateSession({
    required NewTemplateState newTemplateState,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final sessionUUID = await _client.chatSession.startChatFromNewTemplate(
        newTemplateState: newTemplateState,
      );

      state = state.copyWith(
        sessionUUID: sessionUUID,
        templateState: newTemplateState,
        isLoading: false,
        messages: [],
      );
    } on ShoebillException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.description,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to start chat session: $e',
      );
    }
  }

  /// Initialize a chat session for an existing template
  Future<void> startExistingTemplateSession({
    required int templateVersionId,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final sessionUUID = await _client.chatSession.startChatFromExistingTemplate(
        templateVersionId: templateVersionId,
      );

      state = state.copyWith(
        sessionUUID: sessionUUID,
        isLoading: false,
        messages: [],
      );
    } on ShoebillException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.description,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to start chat session: $e',
      );
    }
  }

  /// Resume an existing chat session by its UUID.
  /// This is used when navigating to the chat screen with a session ID,
  /// either from the landing page or via deep linking.
  ///
  /// Note: Since sessions are stored in-memory on the server with a timeout,
  /// this will fail if the session has expired. The error state will be set
  /// and the UI should handle redirecting the user back to the landing page.
  Future<void> resumeSession({
    required String sessionUUID,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    // Set the session UUID immediately - the session was already created
    // by the landing page's schema review dialog
    state = state.copyWith(
      sessionUUID: sessionUUID,
      isLoading: false,
      messages: [],
    );
  }

  /// Send a message in the chat
  Future<void> sendMessage({
    required String message,
    NewSchemaChangePayload? schemaChange,
  }) async {
    final sessionUUID = state.sessionUUID;
    if (sessionUUID == null) {
      state = state.copyWith(errorMessage: 'No active session');
      return;
    }

    if (message.trim().isEmpty) return;

    state = state.copyWith(isSendingMessage: true, clearError: true);

    try {
      final stream = await _client.chatSession.sendMessage(
        sessionUUID: sessionUUID,
        message: message,
        schemaChange: schemaChange,
      );

      await for (final item in stream) {
        if (item is ChatMessageResponse) {
          _addMessage(item.message);
        } else if (item is TemplateStateResponse) {
          state = state.copyWith(templateState: item.currentState);
        }
      }

      state = state.copyWith(isSendingMessage: false);
    } on ShoebillException catch (e) {
      state = state.copyWith(
        isSendingMessage: false,
        errorMessage: e.description,
      );
      _addMessage(ChatMessage(
        role: ChatActor.system,
        style: ChatUIStyle.error,
        content: e.description,
      ));
    } catch (e) {
      state = state.copyWith(
        isSendingMessage: false,
        errorMessage: 'Failed to send message: $e',
      );
      _addMessage(ChatMessage(
        role: ChatActor.system,
        style: ChatUIStyle.error,
        content: 'Failed to send message. Please try again.',
      ));
    }
  }

  /// Deploy the current template
  Future<UuidValue?> deployTemplate() async {
    final sessionUUID = state.sessionUUID;
    if (sessionUUID == null) {
      state = state.copyWith(errorMessage: 'No active session');
      return null;
    }

    if (state.templateState is! DeployReadyTemplateState) {
      state = state.copyWith(errorMessage: 'Template is not ready for deployment');
      return null;
    }

    state = state.copyWith(isDeploying: true, clearError: true);

    try {
      final scaffoldId = await _client.chatSession.deploySession(
        sessionUUID: sessionUUID,
      );

      _addMessage(ChatMessage(
        role: ChatActor.system,
        style: ChatUIStyle.success,
        content: 'Template deployed successfully!',
      ));

      state = state.copyWith(isDeploying: false);
      return scaffoldId;
    } on ShoebillException catch (e) {
      state = state.copyWith(
        isDeploying: false,
        errorMessage: e.description,
      );
      _addMessage(ChatMessage(
        role: ChatActor.system,
        style: ChatUIStyle.error,
        content: 'Deployment failed: ${e.description}',
      ));
      return null;
    } catch (e) {
      state = state.copyWith(
        isDeploying: false,
        errorMessage: 'Failed to deploy template: $e',
      );
      _addMessage(ChatMessage(
        role: ChatActor.system,
        style: ChatUIStyle.error,
        content: 'Deployment failed. Please try again.',
      ));
      return null;
    }
  }

  /// Add a message to the chat
  void _addMessage(ChatMessage message) {
    state = state.copyWith(
      messages: [...state.messages, message],
    );
  }

  /// Clear any error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear all messages (for a fresh start)
  void clearMessages() {
    state = state.copyWith(messages: []);
  }
}

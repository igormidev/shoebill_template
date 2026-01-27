import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/src/features/chat/chat_state.dart';

/// Provider for the chat state notifier, initialized with the Serverpod client
final chatProvider = NotifierProvider<ChatNotifier, ChatState>(() {
  return ChatNotifier();
});

/// Provider to check if the template can be deployed
final canDeployProvider = Provider<bool>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.canDeploy;
});

/// Provider to check if messages can be sent
final canSendMessageProvider = Provider<bool>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.canSendMessage;
});

/// Provider for the current template state
final templateStateProvider = Provider<TemplateCurrentState?>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.templateState;
});

/// Provider to check if the template is deploy-ready
final isDeployReadyProvider = Provider<bool>((ref) {
  final templateState = ref.watch(templateStateProvider);
  return templateState is DeployReadyTemplateState;
});

/// Provider for the messages list
final messagesProvider = Provider<List<ChatMessage>>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.messages;
});

/// Provider for the loading state
final isLoadingProvider = Provider<bool>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.isLoading;
});

/// Provider for the sending message state
final isSendingMessageProvider = Provider<bool>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.isSendingMessage;
});

/// Provider for the deploying state
final isDeployingProvider = Provider<bool>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.isDeploying;
});

/// Provider for error messages
final errorMessageProvider = Provider<String?>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.errorMessage;
});

import 'package:flutter/material.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/gen_l10n/s.dart';
import 'package:shoebill_template_flutter/src/features/chat/widgets/chat_bubble.dart';

/// A scrollable list of chat messages with auto-scroll to bottom
class ChatMessageList extends StatefulWidget {
  final List<ChatMessage> messages;
  final bool isTyping;

  const ChatMessageList({
    super.key,
    required this.messages,
    this.isTyping = false,
  });

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  final ScrollController _scrollController = ScrollController();
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _previousMessageCount = widget.messages.length;
  }

  @override
  void didUpdateWidget(ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Auto-scroll when new messages are added
    if (widget.messages.length > _previousMessageCount) {
      _scrollToBottom();
    }
    _previousMessageCount = widget.messages.length;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    if (widget.messages.isEmpty && !widget.isTyping) {
      return _buildEmptyState(context, theme, l10n);
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE1BEE7), // Lavender/purple background as per mockup
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: widget.messages.length + (widget.isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          // Show typing indicator as the last item
          if (widget.isTyping && index == widget.messages.length) {
            return const ChatTypingIndicator();
          }

          final message = widget.messages[index];
          final showTimestamp = _shouldShowTimestamp(index);

          return ChatBubble(
            message: message,
            showTimestamp: showTimestamp,
          );
        },
      ),
    );
  }

  bool _shouldShowTimestamp(int index) {
    if (index == 0) return true;

    final currentMessage = widget.messages[index];
    final previousMessage = widget.messages[index - 1];

    // Show timestamp if more than 5 minutes have passed
    final difference = currentMessage.timestamp.difference(previousMessage.timestamp);
    return difference.inMinutes > 5;
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, S? l10n) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE1BEE7), // Lavender/purple background
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text(
                l10n?.chat_empty_state ?? 'Start a conversation to build your template',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Describe what kind of PDF template you want to create',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';

/// A reusable chat bubble widget that displays messages with different styles
/// based on the ChatActor (user, ai, system) and ChatUIStyle (normal, thinking, error, success)
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showTimestamp;

  const ChatBubble({
    super.key,
    required this.message,
    this.showTimestamp = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == ChatActor.user;
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleAlignment = isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Align(
            alignment: bubbleAlignment,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getBubbleColor(context),
                borderRadius: _getBorderRadius(isUser),
                border: _getBorder(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_shouldShowRoleLabel()) ...[
                    _buildRoleLabel(context),
                    const SizedBox(height: 4),
                  ],
                  _buildContent(context),
                ],
              ),
            ),
          ),
          if (showTimestamp) ...[
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBubbleColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (message.style) {
      case ChatUIStyle.error:
        return colorScheme.errorContainer;
      case ChatUIStyle.success:
        return Colors.green.shade50;
      case ChatUIStyle.thinkingChunk:
        return colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
      case ChatUIStyle.normal:
        switch (message.role) {
          case ChatActor.user:
            return colorScheme.primaryContainer;
          case ChatActor.ai:
            return colorScheme.secondaryContainer;
          case ChatActor.system:
            return colorScheme.tertiaryContainer;
        }
    }
  }

  Border? _getBorder(BuildContext context) {
    final theme = Theme.of(context);

    if (message.style == ChatUIStyle.thinkingChunk) {
      return Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.3),
        width: 1,
      );
    }

    if (message.style == ChatUIStyle.error) {
      return Border.all(
        color: theme.colorScheme.error.withValues(alpha: 0.5),
        width: 1,
      );
    }

    if (message.style == ChatUIStyle.success) {
      return Border.all(
        color: Colors.green.withValues(alpha: 0.5),
        width: 1,
      );
    }

    return null;
  }

  BorderRadius _getBorderRadius(bool isUser) {
    const radius = Radius.circular(16);
    const smallRadius = Radius.circular(4);

    if (isUser) {
      return const BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: smallRadius,
      );
    } else {
      return const BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: smallRadius,
        bottomRight: radius,
      );
    }
  }

  bool _shouldShowRoleLabel() {
    return message.role == ChatActor.ai || message.role == ChatActor.system;
  }

  Widget _buildRoleLabel(BuildContext context) {
    final theme = Theme.of(context);

    String label;
    IconData icon;
    Color iconColor;

    switch (message.role) {
      case ChatActor.user:
        label = 'You';
        icon = Icons.person;
        iconColor = theme.colorScheme.primary;
      case ChatActor.ai:
        label = message.style == ChatUIStyle.thinkingChunk ? 'AI Thinking' : 'AI';
        icon = Icons.smart_toy;
        iconColor = theme.colorScheme.secondary;
      case ChatActor.system:
        label = 'System';
        icon = Icons.info_outline;
        iconColor = theme.colorScheme.tertiary;
    }

    if (message.style == ChatUIStyle.error) {
      icon = Icons.error_outline;
      iconColor = theme.colorScheme.error;
    } else if (message.style == ChatUIStyle.success) {
      icon = Icons.check_circle_outline;
      iconColor = Colors.green;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: iconColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    Color textColor;
    FontStyle fontStyle = FontStyle.normal;

    switch (message.style) {
      case ChatUIStyle.error:
        textColor = theme.colorScheme.onErrorContainer;
      case ChatUIStyle.success:
        textColor = Colors.green.shade900;
      case ChatUIStyle.thinkingChunk:
        textColor = theme.colorScheme.onSurface.withValues(alpha: 0.7);
        fontStyle = FontStyle.italic;
      case ChatUIStyle.normal:
        switch (message.role) {
          case ChatActor.user:
            textColor = theme.colorScheme.onPrimaryContainer;
          case ChatActor.ai:
            textColor = theme.colorScheme.onSecondaryContainer;
          case ChatActor.system:
            textColor = theme.colorScheme.onTertiaryContainer;
        }
    }

    return SelectableText(
      message.content,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontStyle: fontStyle,
        height: 1.4,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

/// A loading indicator that appears when the AI is processing
class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({super.key});

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.smart_toy,
                size: 14,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      final delay = index * 0.2;
                      final animValue = ((_controller.value + delay) % 1.0);
                      final opacity = (1.0 - (animValue - 0.5).abs() * 2).clamp(0.3, 1.0);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

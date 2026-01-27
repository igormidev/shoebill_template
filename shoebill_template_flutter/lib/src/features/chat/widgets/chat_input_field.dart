import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoebill_template_flutter/gen_l10n/s.dart';

/// A text input field for the chat interface with send button
class ChatInputField extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool enabled;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.onSend,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;

    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    final canSend = widget.enabled && _hasText && !widget.isLoading;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6C9), // Light green background as per mockup
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: CallbackShortcuts(
                  bindings: {
                    // Submit on Enter (without Shift)
                    const SingleActivator(LogicalKeyboardKey.enter): () {
                      if (canSend) _handleSubmit();
                    },
                  },
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: l10n?.chat_input_placeholder ?? 'Type your message...',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildSendButton(context, theme, l10n, canSend),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(
    BuildContext context,
    ThemeData theme,
    S? l10n,
    bool canSend,
  ) {
    if (widget.isLoading) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Material(
      color: canSend ? theme.colorScheme.primary : theme.colorScheme.primary.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: canSend ? _handleSubmit : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            Icons.send,
            color: canSend
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onPrimary.withValues(alpha: 0.5),
            size: 22,
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoebill_template_flutter/gen_l10n/s.dart';

/// Dialog for pasting JSON content manually.
class JsonPasteDialog extends StatefulWidget {
  const JsonPasteDialog({super.key});

  @override
  State<JsonPasteDialog> createState() => _JsonPasteDialogState();
}

class _JsonPasteDialogState extends State<JsonPasteDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isValid = true;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateJson(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        _isValid = false;
        _errorText = S.of(context)!.error_empty_field;
      });
      return;
    }

    try {
      json.decode(value);
      setState(() {
        _isValid = true;
        _errorText = null;
      });
    } catch (e) {
      setState(() {
        _isValid = false;
        _errorText = S.of(context)!.landing_invalid_json;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.landing_paste_json),
      content: SizedBox(
        width: 500,
        height: 400,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paste your JSON content below:',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: '{\n  "key": "value"\n}',
                    border: const OutlineInputBorder(),
                    errorText: _errorText,
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                  onChanged: _validateJson,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.button_cancel),
        ),
        FilledButton(
          onPressed: _isValid && _controller.text.trim().isNotEmpty
              ? () {
                  Navigator.of(context).pop(_controller.text);
                }
              : null,
          child: Text(l10n.button_submit),
        ),
      ],
    );
  }
}

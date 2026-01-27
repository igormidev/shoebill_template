import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:shoebill_template_flutter/gen_l10n/s.dart';

/// A styled drop zone widget for accepting JSON file drops.
class JsonDropZone extends StatelessWidget {
  /// Callback when files are dropped onto the zone.
  final void Function(List<XFile> files) onFileDrop;

  /// Whether the user is currently dragging over the zone.
  final bool isDragging;

  const JsonDropZone({
    super.key,
    required this.onFileDrop,
    required this.isDragging,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final theme = Theme.of(context);

    // Beige/cream color for the drop zone background
    final backgroundColor = isDragging
        ? theme.colorScheme.primaryContainer
        : const Color(0xFFF5F0E6);

    final borderColor = isDragging
        ? theme.colorScheme.primary
        : theme.colorScheme.outline.withValues(alpha: 0.3);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: isDragging ? 3 : 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Trigger file picker through parent
          },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file,
                  size: 64,
                  color: isDragging
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.landing_drag_json,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isDragging
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.landing_drop_files,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmationDialog extends ConsumerWidget {
  final String title;
  final String? description;

  /// Texto do botão de confirmação
  final String confirmText;

  /// Texto do botão de cancelamento
  final String cancelText;

  /// Ícone opcional do botão de confirmação
  final IconData? confirmIcon;

  /// Ícone opcional do botão de cancelamento
  final IconData? cancelIcon;

  /// Estilos opcionais
  final ButtonStyle? confirmButtonStyle;
  final ButtonStyle? cancelButtonStyle;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.description,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.confirmIcon,
    this.cancelIcon,
    this.confirmButtonStyle,
    this.cancelButtonStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),

      title: Text(
        title,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),

      content: description != null
          ? Text(
        description!,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium,
      )
          : null,

      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: cancelButtonStyle,
                onPressed: () => Navigator.of(context).pop(false),
                icon: cancelIcon != null
                  ? Icon(cancelIcon, size: 18)
                  : const SizedBox.shrink(),
                label: Text(cancelText),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton.icon(
                style: confirmButtonStyle,
                onPressed: () => Navigator.of(context).pop(true),
                icon: confirmIcon != null
                  ? Icon(confirmIcon, size: 18)
                  : const SizedBox.shrink(),
                label: Text(
                  confirmText
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

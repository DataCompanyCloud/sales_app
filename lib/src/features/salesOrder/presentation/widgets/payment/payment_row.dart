import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final EdgeInsets? padding;

  const PaymentRow ({
    super.key,
    required this.label,
    required this.value,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(0),
      dashPattern: const [4, 3],
      color: scheme.outlineVariant,
      strokeWidth: 1,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      customPath: (size) {
        return Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width, size.height);
      },
      child: Padding(
        padding: padding ?? const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: scheme.outlineVariant)),
            Text(value),
          ],
        ),
      ),
    );
  }
}
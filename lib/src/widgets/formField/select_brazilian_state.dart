import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SelectBrazilianState extends ConsumerWidget {
  final BrazilianState? value;
  final bool isLoading;
  final bool required;
  final VoidCallback? onChange;

  const SelectBrazilianState({
    super.key,
    this.value,
    this.isLoading = false,
    this.required = false,
    this.onChange
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: onChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "Estado",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface
                ),
                children: required
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
              ),
            ),
            SizedBox(height: 4),
            Container(
              height: 48,
              constraints: BoxConstraints(
                minWidth: 48
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: scheme.outline.withValues(alpha: 0.33),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: scheme.outline,
                  width: 2
                )
              ),
              child: Row(
                children: [
                  Text(
                    value?.name ?? "--",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

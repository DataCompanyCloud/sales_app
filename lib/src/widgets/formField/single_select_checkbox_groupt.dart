import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SingleSelectCheckboxGroup<T> extends ConsumerWidget {
  final List<T> items;
  final T? selected;
  final bool isLoading;
  final bool required;
  final String? label;
  final String Function(T) valueLabelBuilder;
  final ValueChanged<T> onChanged;

  const SingleSelectCheckboxGroup({
    super.key,
    required this.items,
    required this.selected,
    required this.valueLabelBuilder,
    required this.onChanged,
    this.label,
    this.isLoading = false,
    this.required = false
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
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
          Column(
            children: items.map((item) {
              final isSelected = item == selected;
              return InkWell(
                onTap: () => onChanged(item),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                        ? scheme.primary
                        : scheme.outline,
                      width: 2
                    ),
                    color: isSelected
                      ? scheme.primary.withValues(alpha: .08)
                      : scheme.surface,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => onChanged(item),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          valueLabelBuilder(item),
                          style: TextStyle(
                            fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
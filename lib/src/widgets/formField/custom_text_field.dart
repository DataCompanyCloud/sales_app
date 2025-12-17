import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:skeletonizer/skeletonizer.dart';


class CustomTextField extends ConsumerWidget{
  final TextEditingController controller;
  final List<MaskTextInputFormatter> masks;
  final bool isLoading;
  final TextInputType? keyboardType;
  final IconData? icon;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final bool hasBottomMargin;
  final bool required;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    this.required = false,
    this.isLoading = false,
    this.masks = const [],
    this.keyboardType,
    this.labelText,
    this.hintText,
    this.helperText,
    this.hasBottomMargin = true,
    this.errorText,
    this.icon,
    this.enabled = true
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Skeletonizer(
      enabled: isLoading,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: labelText,
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
            TextField(
              enabled: enabled,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              inputFormatters: masks,
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                filled: true,
                fillColor: enabled
                    ? scheme.outline.withValues(alpha: 0.33)
                    : scheme.outline.withValues(alpha: 0.77),
                prefixIcon: icon == null ? null : Icon(icon),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.clear,
                        size: 18,
                      ),
                      onPressed: () {
                        controller.clear();
                      },
                    );
                  },
                ),
                hintText: hintText ?? "",
                hintStyle: TextStyle(
                  color: Colors.grey
                ),
                errorText:  errorText,
                helperText: hasBottomMargin ? (helperText ?? "") : null,
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: scheme.outline,
                    width: 2
                  )
                ),
                errorBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2
                  )
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2
                  )
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: scheme.outline,
                    width: 2
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: scheme.primary,
                    width: 2
                  )
                )
              ),
            ),
          ],
        ),
    );
  }
}



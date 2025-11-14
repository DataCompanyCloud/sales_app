import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaqQuestionCard extends ConsumerStatefulWidget {

  const FaqQuestionCard({
    super.key
  });

  @override
  ConsumerState<FaqQuestionCard> createState() => _FaqQuestionCardState();
}

class _FaqQuestionCardState extends ConsumerState<FaqQuestionCard>{
  final isExpandedProvider = StateProvider<bool>((_) => false);

  @override
  Widget build(BuildContext context) {
    final isExpanded = ref.watch(isExpandedProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => ref.read(isExpandedProvider.notifier).state = !isExpanded,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Pergunta?",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Icon(
                      isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                      size: 28,
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: SizedBox.shrink(),
                  secondChild: Padding(
                    padding: EdgeInsets.only(top: 12, left: 4, right: 4, bottom: 8),
                    child: Text(
                      "Solução... Solução... Solução... Solução... Solução... Solução... Solução... Solução... Solução... Solução... Solução... Solução... Solução... Solução... Solução...",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
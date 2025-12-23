import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/credit_limit.dart';

class CreditLimitSection extends ConsumerStatefulWidget {
  final CreditLimit? creditLimit;
  final VoidCallback? onAddPressed;
  final ValueChanged<CreditLimit>? onDelete;
  final ValueChanged<CreditLimit>? onEdit;
  final bool required;

  const CreditLimitSection({
    super.key,
    this.creditLimit,
    this.onAddPressed,
    this.onDelete,
    this.onEdit,
    this.required = false
  });

  @override
  ConsumerState<CreditLimitSection> createState() => CreditLimitSectionState();
}

class CreditLimitSectionState extends ConsumerState<CreditLimitSection> {
  @override
  Widget build(BuildContext context) {
    final creditLimit = widget.creditLimit;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.credit_score,
                  color: scheme.primary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Limite de Crédito",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        ),
                        children: widget.required
                            ? const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]
                            : [],
                      ),
                    ),
                    Text(
                      creditLimit == null
                        ? "Nenhum limite informado"
                        : "Configure o limite de crédito do cliente"
                      ,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: widget.onAddPressed,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar'),
                style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: scheme.outline, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          creditLimit != null
            ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outline),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.credit_score,
                    size: 18,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creditLimit.available.format(scale: 2),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.onEdit != null
                  ? IconButton(
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      color: scheme.primary,
                      onPressed: () => widget.onEdit!(creditLimit),
                    )
                  : SizedBox.shrink()
                ,
                SizedBox(width: 8),
                widget.onDelete != null
                    ? IconButton(
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                  ),
                  color: scheme.primary,
                  onPressed: () => widget.onDelete!(creditLimit),
                )
                    : SizedBox.shrink(),
              ],
            ),
          )
            : SizedBox.shrink()
          ,

        ],
      ),
    );
  }
}
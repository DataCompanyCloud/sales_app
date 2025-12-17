
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/widgets/draggable/payment_method_draggable.dart';

class PaymentMethodSection extends ConsumerWidget {
  final List<PaymentMethod> paymentMethods;
  final VoidCallback? onAddPressed;
  final ValueChanged<PaymentMethod>? onDelete;
  final bool required;
  final String? errorMessage;


  const PaymentMethodSection({super.key,
    required this.paymentMethods,
    this.onAddPressed,
    this.onDelete,
    this.required = false,
    this.errorMessage
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
                  Icons.payments,
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
                        text: "Formas de pagamento",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
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
                    Text(
                      paymentMethods.isEmpty
                        ? "Nenhuma forma de pagamento informada"
                        : "Configure como seus clientes podem pagar"
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
                onPressed: onAddPressed,
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
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: paymentMethods.isNotEmpty ? 12 : 0,
            ),
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) {
              final payment = paymentMethods[index];
              return Container(
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
                        payment.icon,
                        size: 18,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        payment.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onDelete != null
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
                          onPressed: () => onDelete!(payment),
                        )
                      : Icon(
                        Icons.check_circle,
                        color: scheme.primary,
                        size: 20,
                      ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4);
            }
          ),
          if (errorMessage != null)
            Column(
              children: [
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer.withValues(alpha: .6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: scheme.error.withValues(alpha: .4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: scheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage ?? "Erro",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onErrorContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
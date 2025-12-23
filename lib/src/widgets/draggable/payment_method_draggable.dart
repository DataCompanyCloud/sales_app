import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';


class PaymentMethodDraggable extends ConsumerStatefulWidget {
  final Set<PaymentMethod> selected;
  const PaymentMethodDraggable({
    super.key,
    this.selected = const {}
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PaymentMethodDraggableState();
}

class PaymentMethodDraggableState extends ConsumerState<PaymentMethodDraggable> {
  late final StateProvider<Set<PaymentMethod>> _paymentMethodsSelectedProvider ;

  @override
  void initState() {
    super.initState();
    _paymentMethodsSelectedProvider = StateProvider<Set<PaymentMethod>>((ref) => widget.selected);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(_paymentMethodsSelectedProvider);
    final scheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Selecionar forma de pagamento',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Lista
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: PaymentMethod.values.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final method = PaymentMethod.values[index];
                    final isSelected = selected.contains(method);

                    if (method == PaymentMethod.outros) return SizedBox.shrink();
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        final notifier = ref.read(_paymentMethodsSelectedProvider.notifier);

                        notifier.state = isSelected
                          ? ({...selected}..remove(method))
                          : ({...selected}..add(method))
                        ;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? scheme.primary
                                : scheme.outline,
                          ),
                          color: isSelected
                              ? scheme.primary.withValues(alpha: 20)
                              : scheme.surface,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              method.icon,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                method.label,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: scheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Botões
              SafeArea(
                top: false,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2, color: scheme.outline)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // salvar seleção
                              Navigator.pop(context, selected.toList());
                            },
                            child: const Text('Salvar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension PaymentMethodX on PaymentMethod {
  IconData get icon {
    switch (this) {
      case PaymentMethod.pix:
        return Icons.qr_code;
      case PaymentMethod.cartaoCredito:
        return Icons.credit_card;
      case PaymentMethod.cartaoDebito:
        return Icons.credit_card_outlined;
      case PaymentMethod.boleto:
        return Icons.receipt_long;
      case PaymentMethod.transferencia:
        return Icons.arrow_circle_right_outlined;
      case PaymentMethod.cheque:
        return Icons.money_outlined;
      case PaymentMethod.dinheiro:
        return Icons.money;
      default:
        return Icons.payments;
    }
  }
}
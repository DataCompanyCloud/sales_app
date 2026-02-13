import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';

class SalesOrderFinishedSection extends ConsumerStatefulWidget {
  final SalesOrder?  order;

  const SalesOrderFinishedSection({
    super.key,
    required this.order,
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SalesOrderFinishedSectionState();
}

class SalesOrderFinishedSectionState extends ConsumerState<SalesOrderFinishedSection> {
  final StateProvider<bool> _isExpandedProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context) {
    final isExpanded = ref.watch(_isExpandedProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final salesOrder = widget.order;
    final salesOrderProducts = salesOrder?.items ?? [];

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
                border: Border(
                  top: BorderSide(
                    color: scheme.outline,
                    width: 2
                  ),
                  left: BorderSide(
                    color: scheme.outline,
                    width: 2
                  ),
                  right: BorderSide(
                    color: scheme.outline,
                    width: 2
                  )
                ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft:  Radius.circular(12),
              )
            ),
            child: Column(
              children: [
                salesOrderProducts.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          ref.read(_isExpandedProvider.notifier).state = !isExpanded;
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    isExpanded ? "Pagamento" : "Total: R\$ ${salesOrder?.calcItemsSubtotal.decimalValue ?? 0}",
                                    key: ValueKey(isExpanded),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                              child: Row(
                                children: [
                                  Text("Detalhes"),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.0 : 0.5, // gira o ícone
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(Icons.expand_more),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
                isExpanded
                  ? Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal'),
                            Text(
                              'R\$ ${salesOrder?.calcItemsSubtotal.decimalValue ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Desconto'),
                            Text(
                              'R\$ ${salesOrder?.calcDiscountTotal.decimalValue ?? 0}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Imposto'),
                            Text(
                              'R\$ 0.0',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Frete'),
                            Text(
                              'R\$ ${salesOrder?.freight?.decimalValue ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: scheme.outline,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                            ),
                            Text(
                              'R\$ ${salesOrder?.calcGrandTotal.decimalValue ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  : SizedBox.shrink()
              ],
            ),
          ),
          Column(
            children: [
              salesOrder?.customerId == null
                ? Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: scheme.onPrimary
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Selecione um cliente",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: scheme.onPrimary
                          ),
                        ),
                      ],
                    ),
                  )
                : salesOrderProducts.isEmpty
                  ? Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                    ),
                    child: Row(
                      children: [
                        Icon(
                            Icons.info_outline,
                            color: scheme.onPrimary
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Selecione um produto",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: scheme.onPrimary
                          ),
                        ),
                      ],
                    ),
                  )
                  : SizedBox.shrink()
              ,
              Container(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 24, bottom: 24),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: scheme.outline,
                      width: 2
                    )
                  )
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent, // fundo transparente
                          side: BorderSide(
                            color: scheme.onSurface, // cor da borda
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // borda arredondada
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Enviar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurface
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: scheme.primary, // fundo transparente
                          side: const BorderSide(
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // borda arredondada
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Finalizar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: scheme.onPrimary
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

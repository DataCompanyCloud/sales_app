import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/order/domain/entities/order_product.dart';

class OrderDetailsCard extends ConsumerStatefulWidget {
  final OrderProduct orderProduct;

  const OrderDetailsCard({
    super.key,
    required this.orderProduct,
  });

  @override
  ConsumerState<OrderDetailsCard> createState() => _OrderDetailsCardState();
}

class _OrderDetailsCardState extends ConsumerState<OrderDetailsCard>{
  final isExpandedProvider = StateProvider<bool>((_) => false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final isExpanded = ref.watch(isExpandedProvider);

    final categories = List.generate(6, (index) => "Categ. ${index + 1}");
    final visibleCategories = isExpanded ? categories : categories.take(3).toList();

    return Container(
      height: isExpanded ? null : 180,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.onTertiary, width: 2),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.orderProduct.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      Text("Qtd: ${widget.orderProduct.quantity.toStringAsFixed(0)}"),
                      Text("Desconto: ${widget.orderProduct.discountAmount.decimalValue}"),
                      Text("Preço Unit.: ${widget.orderProduct.unitPrice.decimalValue}"),
                      Text("Total: R\$${widget.orderProduct.totalValue.format()}"),
                      GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 3,
                        children: visibleCategories.map((c) {
                          return Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: scheme.primary, width: 1),
                              color: scheme.onSecondary,
                            ),
                            child: Center(child: Text(c)),
                          );
                        }).toList(),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(isExpandedProvider.notifier).state = !isExpanded;
                        },
                        child: Text(
                          isExpanded ? "Ver menos" : "Ver mais...",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(Icons.chevron_right, size: 28),
            ),
          ),
        ],
      )
    );
  }
}

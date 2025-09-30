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

class _OrderDetailsCardState extends ConsumerState<OrderDetailsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final categories = List.generate(6, (index) => "Categ. ${index + 1}");
    final visibleCategories = _isExpanded ? categories : categories.take(3).toList();

    return Container(
      height: _isExpanded ? null : 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.onTertiary, width: 2),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
              ),
            ),
          ),
          Positioned.fill(
            left: 96,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderProduct.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: 30,
                          child: GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: 3,
                            children: visibleCategories.map((c) {
                              return Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: scheme.primary, width: 1),
                                  color: scheme.onSecondary,
                                ),
                                child: Center(child: Text(c)),
                              );
                            }).toList(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            _isExpanded ? "Ver menos" : "Ver mais...",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Text(
                          "Qtd: ${widget.orderProduct.quantity.toStringAsFixed(0)}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Desconto: ${widget.orderProduct.discountAmount.decimalValue}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Preço Unit.: ${widget.orderProduct.unitPrice.decimalValue}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Total: R\$${widget.orderProduct.totalValue.format()}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(Icons.chevron_right, size: 28),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';

class SalesOrderProductCard extends ConsumerWidget {
  final SalesOrderProduct item;

  const SalesOrderProductCard({
    super.key,
    required this.item
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: item.quantity.toInt().toString());
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outline, width: 2)
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
               'assets/images/not_found.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${item.productName} ${item.productName} ${item.productName}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        )
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  "10 disponível",
                  style: TextStyle(
                   fontSize: 12
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "R\$ ${item.totalValue.decimalValue}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                          Text(
                            "Imp. (R\$ ${item.taxAmount.decimalValue})",
                            style: TextStyle(
                              fontSize: 11
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: scheme.outline, width: 2)
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: scheme.outline, width: 2)
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: controller,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                final n = int.tryParse(text);
                                // if (n != null) updateValue(n);
                              },
                              decoration: const InputDecoration(
                                fillColor: Colors.transparent,
                                isCollapsed: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: scheme.outline, width: 2)
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
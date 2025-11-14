import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order_product.dart';

class OrderDetailsList extends ConsumerWidget {
  final OrderProduct orderProduct;

  const OrderDetailsList({
    super.key,
    required this.orderProduct
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(0),
      dashPattern: const [4, 3],
      color: Colors.grey,
      strokeWidth: 1,
      padding: EdgeInsets.symmetric(vertical: 8),
      customPath: (size) {
        return Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width, size.height);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              orderProduct.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16
              ),
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 6, right: 6),
                      decoration: BoxDecoration(
                        color: scheme.secondaryContainer,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "x${orderProduct.quantity.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: scheme.onSurface,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "R\$${orderProduct.unitPrice.decimalValue}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.red,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.discount,
                            color: Colors.white,
                            size: 16,
                          ),
                          Text(
                            " R\$ -${orderProduct.discountAmount.format()}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "R\$${orderProduct.totalValue.format()}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
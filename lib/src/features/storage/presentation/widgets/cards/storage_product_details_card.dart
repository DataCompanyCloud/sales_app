import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';

class StorageProductDetailsCard extends ConsumerWidget {
  final StorageProduct product;

  const StorageProductDetailsCard({
    super.key,
    required this.product
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline, width: 2)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 75,
                        height: 20,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10)
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          product.productCode,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10)
                          ),
                          color: scheme.primary
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            color: scheme.onSurface,
                            size: 38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              ),
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: TextStyle(
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: scheme.surfaceContainerHighest,
                                      border: Border.all(color: scheme.shadow),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "Quantidade: ${product.quantity}",
                                      style: TextStyle(
                                        color: scheme.onSecondaryContainer,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
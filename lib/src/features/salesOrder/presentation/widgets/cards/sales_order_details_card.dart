import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';

class SalesOrderDetailsCard extends ConsumerStatefulWidget {
  final SalesOrderProduct orderProduct;

  const SalesOrderDetailsCard({
    super.key,
    required this.orderProduct,
  });

  @override
  ConsumerState<SalesOrderDetailsCard> createState() => _OrderDetailsCardState();
}

class _OrderDetailsCardState extends ConsumerState<SalesOrderDetailsCard>{
  final isExpandedProvider = StateProvider<bool>((_) => false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final orderProduct = widget.orderProduct;

    final isExpanded = ref.watch(isExpandedProvider);

    final categories = List.generate(9, (index) => "Azul");
    final visibleCategories = isExpanded ? categories : categories.take(3).toList();

    final image = orderProduct.images?.firstOrNull;
    final imageUrl = image?.url;

    return Container(
      height: isExpanded ? null : 300,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline, width: 2),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          orderProduct.productCode,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 28),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 90,
                            height: 90,
                            color: Color(0xFFE5E7EB),
                            foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Color(0xFFE5E7EB), width: 2),
                            ),
                            child:
                            imageUrl == null
                                ? Image.asset(
                              image?.url ?? 'assets/images/not_found.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                                : Image.network(imageUrl)
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            orderProduct.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: scheme.onPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(Icons.unarchive_outlined, size: 20),
                              ),
                              Text(
                                "Quantidade: ",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          Text(
                            orderProduct.quantity.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: Divider(color: scheme.surface, thickness: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(Icons.star, size: 20),
                                ),
                                Text(
                                  "Preço Unit.: ",
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "R\$ ${orderProduct.unitPrice.decimalValue}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: Divider(color: scheme.surface, thickness: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(Icons.discount_outlined, size: 20),
                                ),
                                Text(
                                  "Desconto: ",
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "R\$ ${orderProduct.discountAmount.decimalValue}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: Divider(color: scheme.surface, thickness: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(Icons.attach_money, size: 20),
                                ),
                                Text(
                                  "Subtotal: ",
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "R\$ ${orderProduct.totalValue.format()}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  // GridView.count(
                  //   crossAxisCount: 3,
                  //   mainAxisSpacing: 6,
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   childAspectRatio: 4,
                  //   children: visibleCategories.map((c) {
                  //     return Container(
                  //       margin: EdgeInsets.only(right: 8),
                  //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(8),
                  //         border: Border.all(color: scheme.primary, width: 1),
                  //         color: scheme.onSecondary,
                  //       ),
                  //       alignment: Alignment.center,
                  //       child: Text(
                  //         c,
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     ref.read(isExpandedProvider.notifier).state = !isExpanded;
                  //   },
                  //   child: Text(
                  //     isExpanded ? "Ver menos" : "Ver mais...",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.blue,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Positioned(
          //   right: 8,
          //   top: 0,
          //   bottom: 0,
          //   child: Center(
          //     child: Icon(Icons.chevron_right, size: 28),
          //   ),
          // ),
        ],
      )
    );
  }
}

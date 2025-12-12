import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/images/presentation/controllers/valueObjects/product_image_cached.dart';
import 'package:sales_app/src/features/images/presentation/widgets/product_image_cached_widget.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/providers.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/product/bottomSheet/select_product_bottom_sheet.dart';
import 'package:sales_app/src/features/images/presentation/widgets/image_widget.dart';


class SelectProductCard extends ConsumerStatefulWidget {
  final Product product;
  final SalesOrderProduct? salesOrderProduct;

  const SelectProductCard({
    super.key,
    required this.product,
    required this.salesOrderProduct
  });

  @override
  ConsumerState<SelectProductCard> createState() => SelectProductCardState();
}

class SelectProductCardState extends ConsumerState<SelectProductCard> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    final quantity = (widget.salesOrderProduct?.quantity ?? 0).toInt();
    controller = TextEditingController(text: quantity.toString());
    focusNode = FocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.read(productCartControllerProvider.notifier);
    final product = widget.product;
    final salesOrderProduct = widget.salesOrderProduct;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          width: 4,
          color: salesOrderProduct == null
            ? scheme.surfaceContainerHigh
            : scheme.outlineVariant
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    // border: Border.all(color: Color(0xFFE5E7EB), width: 2),
                  ),
                  child:
                  ProductImageCachedWidget(
                    productId: product.productId,
                    image: product.imagePrimary,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover
                  )
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "-30%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              product.attributes.length > 1
               ? SizedBox.shrink()
               : Positioned.fill(
                bottom: 4,
                right: 8,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6)
                      ),
                    ),
                    child: Text(
                      "R\$ ${product.price.format(scale: 2)}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 4,
                left: 8,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6)
                      ),
                    ),
                    child: Text(
                      product.code,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              salesOrderProduct != null
                ? Positioned(
                top: 8,
                right: 8,
                child: Card(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(4),
                    // side: BorderSide(color: scheme.outline, width: 2)
                  ),
                  child: InkWell(
                    onTap: () {
                      cart.setProductQuantity(product, 0);
                      controller.text = "0";

                      controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: controller.text.length,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    )
                  ),
                ),
              )
                : SizedBox.shrink()
              ,
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            // color: Colors.red,
            child: 
              product.attributes.length > 1
                ? Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4)
                    ),
                    side: BorderSide(color: scheme.outline, width: 2)
                  ),
                  child: InkWell(
                    onTap: () async {
                      final selected = await showModalBottomSheet<SalesOrderProduct?>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return SelectProductBottomSheet(product: product);
                        },
                      );

                      print(selected);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheme.outline
                      ),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Icon(Icons.shopping_cart, size: 18),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Adicionar",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    )
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadiusGeometry.only(
                           topLeft: Radius.circular(4),
                           bottomLeft: Radius.circular(4),
                           topRight: Radius.circular(4),
                           bottomRight: Radius.circular(4)
                         ),
                         side: BorderSide(color: scheme.outline, width: 2)
                       ),
                       child: InkWell(
                        onTap: () {
                          final current = max((int.tryParse(controller.text) ?? 0) -1, 0);
                          controller.text = current.toString();

                          cart.setProductQuantity(product, current);

                          controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: controller.text.length,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.remove,
                            size: 20,
                          ),
                        ),
                      ),
                     ),
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: scheme.outline, width: 2),
                          bottom: BorderSide(color: scheme.outline, width: 2)
                        )
                      ),
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          final n =  max(int.tryParse(text) ?? 0, 0);

                          cart.setProductQuantity(product, n);
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
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4)
                        ),
                        side: BorderSide(color: scheme.outline, width: 2)
                      ),
                      child: InkWell(
                        onTap: () {
                          final current = (int.tryParse(controller.text) ?? 0) + 1;
                          controller.text = current.toString();

                          cart.setProductQuantity(product, current);

                          controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: controller.text.length,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.add,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ,
          )
        ],
      ),
    );
  }


}

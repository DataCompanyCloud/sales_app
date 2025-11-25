import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/widgets/image_widget.dart';

class ListViewColumnBig extends ConsumerWidget {
  final List<Product> products;

  const ListViewColumnBig ({
    super.key,
    required this.products
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final image = product.images.firstOrNull;

        return Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.tertiary, width: 2)
          ),
          child: InkWell(
            onTap: () {
              context.pushNamed(ProductRouter.productDetails.name, extra: product);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                    ),
                    color: Colors.grey.shade300,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                    ),
                    child: ImageWidget(
                      path: image?.url,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "R\$${product.price}",
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                          Text(
                            product.name,
                            style: TextStyle(color: colorScheme.onSurface),
                          )
                        ],
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
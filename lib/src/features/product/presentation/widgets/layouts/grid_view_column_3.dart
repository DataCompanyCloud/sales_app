import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/widgets/image_widget.dart';

class GridViewColumn3 extends ConsumerWidget {
  final List<Product> products;

  const GridViewColumn3({
    super.key,
    required this.products
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 0.7,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      children: List.generate(products.length, (index) {
        final product = products[index];
        final image = product.images.firstOrNull;

        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: colorScheme.tertiary, width: 2)
          ),
          child: InkWell(
            onTap: () {
              context.pushNamed(ProductRouter.productDetails.name, extra: product);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Expanded(
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)
                          ),
                          color: Colors.grey.shade300,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                          ),
                          child: ImageWidget(
                            image: image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 6, top: 4, right: 4, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "R\$${product.price}",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        Text(
                          product.name,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

}
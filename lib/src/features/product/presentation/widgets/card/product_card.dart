import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/images/presentation/widgets/product_image_cached_widget.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

class ProductCard extends ConsumerStatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductCard> createState() => ProductCardState();
}

class ProductCardState extends ConsumerState<ProductCard> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          width: 4,
          color: scheme.surfaceContainerHigh
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
                  child: ProductImageCachedWidget(
                    productId: product.id,
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
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Text(
              product.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }


}

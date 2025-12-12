import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/my_device.dart';
import 'package:sales_app/src/features/images/presentation/widgets/product_image_cached_widget.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

class ProductDetailsCard extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsCard({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailsCard> createState() => ProductDetailsCardState();
}

class ProductDetailsCardState extends ConsumerState<ProductDetailsCard> {
  late final FocusNode focusNode;
  final _openProvider = StateProvider((ref) => false);

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

    final device = MyDevice.getType(context);
    final isMobile = device == DeviceType.mobile;

    final double imageSize = isMobile ? 120 : 160;

    bool showDetails = ref.watch(_openProvider);
    return Card(
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          width: 4,
          color: scheme.surfaceContainerHigh
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Container(
                          // padding: EdgeInsets.all(4),
                          foregroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            // border: Border.all(color: Color(0xFFE5E7EB), width: 2),
                          ),
                          child: ProductImageCachedWidget(
                            productId: product.productId,
                            image: product.imagePrimary,
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.cover
                          )
                      ),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
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
                  ],
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: imageSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              _tags("Código"),
                              SizedBox(width: 4),
                              Text(product.code),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          child: Row(
                            children: [
                              _tags("Código"),
                              SizedBox(width: 4),
                              Text(product.code),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          child: Row(
                            children: [
                              _tags("Cod. Barras"),
                              SizedBox(width: 4),
                              Text(product.barcode?.value ?? "--"),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          child: Row(
                            children: [
                              _tags("Preço"),
                              SizedBox(width: 4),
                              Text("R\$ ${product.price.format(scale: 2)}")
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          child: Row(
                            children: [
                              _tags("Estoque"),
                              SizedBox(width: 4),
                              Text("12")
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
            SizedBox(height: 4),
            Divider(
              height: 12,
              thickness: 2,
              color: scheme.outline,
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                ref.read(_openProvider.notifier).state = !showDetails;
              },
              child: Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // --- EXPANSÃO ANIMADA (dentro do Card) ---
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) {
                return ClipRect(
                  child: SizeTransition(
                    sizeFactor: anim,
                    axisAlignment: -1, // expande "de cima pra baixo"
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                );
              },
              child: showDetails
                ? Padding(
                    key: const ValueKey('details'),
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      product.description ?? "--",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : const SizedBox(
                  key: ValueKey('empty'),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tags(String text) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
      decoration: BoxDecoration(
        color: scheme.outline,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6)
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

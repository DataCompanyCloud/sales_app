import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/my_device.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';

class GridViewColumn extends ConsumerWidget {
  final List<Product> products;

  const GridViewColumn({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = MyDevice.getType(context);

    return MasonryGridView.builder(
      // ✅ no builder use gridDelegate
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: device == DeviceType.mobile
          ? 2
          : 4
        ,
      ),
      padding: const EdgeInsets.all(14),
      physics: const AlwaysScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      cacheExtent: 900,
      itemCount: products.length,
      itemBuilder: (context, i) {
        final product = products[i];
        final image = product.images.firstOrNull;
        final imageUrl = image?.url;

        return Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            // side: const BorderSide(color: Color(0xFFE5E7EB)), // opcional: borda sutil
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.pushNamed(ProductRouter.productDetails.name, extra: product);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                  child: Container(
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(color: Color(0xFFE5E7EB), width: 2),
                    ),
                    child:
                    imageUrl == null
                        ? Image.asset(
                      image?.url ?? 'assets/images/not_found.png',
                      width: double.infinity,
                      // height: 138,
                      fit: BoxFit.cover,
                    )
                        : Image.network(imageUrl)
                  ),
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 8.0, bottom: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(
                          product.code,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        labelPadding: EdgeInsets.only(left: 8, right: 8),
                        padding: EdgeInsets.all(0),
                      ),
                      Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "R\$ ${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
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
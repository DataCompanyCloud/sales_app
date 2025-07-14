import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

class ListViewColumnBig extends ConsumerWidget {
  final List<Product> products;

  const ListViewColumnBig ({
    super.key,
    required this.products
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final image = product.images.firstOrNull;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200, width: 2)
            ),
            child: InkWell(
              onTap: () {
                context.push(
                    '/product/product_details',
                    extra: product
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
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
                          bottomLeft: Radius.circular(10)
                      ),
                      child: Image.asset(
                        image?.url ?? 'C:/Users/New/Documents/AndroidStudioProjects/converter_screens_erp/lib/presentation/assets/images/not_found.png',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                  "${product.price}"
                              ),
                              Text(
                                product.name,
                                style: TextStyle(color: Colors.grey.shade700),
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
      ),
    );
  }


}
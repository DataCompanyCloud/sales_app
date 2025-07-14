import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_providers.dart';

class ProductDetails extends ConsumerWidget {
  final String title;
  final Product products;

  const ProductDetails ({
    super.key,
    required this.title,
    required this.products
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(productViewModelProvider);
    final controller = PageController();
    final product = products;
    final image = product.images.firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
            onPressed: () {
              ref.read(productViewModelProvider).selectedImage(0);
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
      ),
      body: SizedBox(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: 4,
                onPageChanged: (index) {
                  viewModelProvider.selectedImage(index);
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    image?.url ?? 'assets/images/not_found.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                        (index) =>
                        AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          width: viewModelProvider.currentPage == index ? 12 : 8,
                          height: viewModelProvider.currentPage == index ? 12 : 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: viewModelProvider.currentPage == index
                                ? Colors.blue
                                : Colors.black26,
                          ),
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 14, left: 12, right: 12, bottom: 56,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_purple500_sharp,
                            color: Colors.black,
                            size: 22,
                          ),
                          SizedBox(width: 2),
                          Text(
                            "4.9mil vendidos",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Divider(
                      color: Colors.black26,
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 4, left: 8),
                      child: ReadMoreText(
                        "Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição, Descrição. ",
                        style: TextStyle(color: Colors.grey),
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: "Leia mais",
                        trimExpandedText: "Mostrar menos",
                        moreStyle: TextStyle(
                          color: Color(0xFF0081F5),
                          fontWeight: FontWeight.bold,
                        ),
                        lessStyle: TextStyle(
                          color: Color(0xFF0081F5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "R\$100,00",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough
                              ),
                            ),
                            Text(
                              // product.price,
                              "R\$${product.price}",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0081F5),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(Icons.outbox_rounded, size: 22),
                          label: Text(
                            "Adicionar no Pedido",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
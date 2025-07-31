import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error_page/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_controller_old.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_providers.dart';
import 'package:sales_app/src/features/product/presentation/widgets/draggable/draggable_layout_product.dart';
import 'package:sales_app/src/features/product/presentation/widgets/layouts/grid_view_column_2.dart';
import 'package:sales_app/src/features/product/presentation/widgets/layouts/grid_view_column_3.dart';
import 'package:sales_app/src/features/product/presentation/widgets/layouts/list_view_column_big.dart';
import 'package:sales_app/src/features/product/presentation/widgets/layouts/list_view_column_small.dart';
import 'package:sales_app/src/features/product/presentation/widgets/skeleton/grid_view_column_2_skeleton.dart';
import 'package:sales_app/src/features/product/providers.dart';

class ProductPage extends ConsumerWidget {
  final String title;

  const ProductPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(productIndexProvider);
    final viewModelProvider = ref.watch(productViewModelProvider);
    final controller = ref.watch(productControllerProvider);

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => GridViewColumn2Skeleton(),
      data: (product) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: IconButton(
                onPressed: () {
                  context.goNamed(HomeRouter.home.name);
                },
                icon: Icon(Icons.arrow_back_ios_new, size: 22)
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: IconButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.sync)
                ),
              )
            ],
            backgroundColor: Color(0xFF0081F5),
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0081F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Icon(Icons.filter_alt, color: Colors.white, size: 22)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: SizedBox(
                          width: 90,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => DraggableLayoutProduct()
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0081F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Icon(Icons.remove_red_eye, color: Colors.white, size: 22)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: switch(viewModelProvider.layoutProduct) {
                    LayoutProduct.listSmallCard => ListViewColumnSmall(products: viewModelProvider.products),
                    LayoutProduct.listBigCard => ListViewColumnBig(products: viewModelProvider.products),
                    LayoutProduct.gridColumn2 => GridViewColumn2(products: viewModelProvider.products),
                    LayoutProduct.gridColumn3 => GridViewColumn3(products: viewModelProvider.products),
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
        );
      }
    );
  }
}
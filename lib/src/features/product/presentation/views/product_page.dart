import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
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

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProductPageState();
}


class ProductPageState extends ConsumerState<ProductPage>{
  final productIndexProvider = StateProvider<int>((ref) => 0);
  final isSearchOpenProvider = StateProvider<bool>((_) => false);
  final searchQueryProvider = StateProvider<String>((_) => '');
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final isOpen = ref.read(isSearchOpenProvider.notifier);
    isOpen.state = !isOpen.state;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(productIndexProvider);
    final viewModelProvider = ref.watch(productViewModelProvider);
    final controller = ref.watch(productControllerProvider);

    final isSearchOpen = ref.watch(isSearchOpenProvider);

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
            title: Text("Produtos"),
            leading: IconButton(
              onPressed: () {
                context.goNamed(HomeRouter.home.name);
              },
              icon: Icon(Icons.arrow_back_ios_new, size: 22)
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => DraggableLayoutProduct()
                  );
                },
                icon: Icon(Icons.remove_red_eye)
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_alt)
              ),
              IconButton(
                onPressed: _toggleSearch,
                icon: Icon(isSearchOpen ? Icons.close : Icons.search),
              ),
            ],
            backgroundColor: Color(0xFF0081F5),
            foregroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              if (controller.isLoading) return;
              ref.refresh(productControllerProvider);
            },
            child: Column(
              children: [
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isSearchOpen
                      ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Pesquisar...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                        /// TODO: Adicionar lógica para filtro de produtos
                      },
                    ),
                  ) : SizedBox.shrink(),
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/my_device.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/product/presentation/widgets/draggable/draggable_layout_product.dart';
import 'package:sales_app/src/features/product/presentation/widgets/skeleton/grid_view_column_skeleton.dart';
import 'package:sales_app/src/features/product/providers.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/product/card/select_product_card.dart';
import 'package:sales_app/src/widgets/image_widget.dart';

class SelectProductsPage extends ConsumerStatefulWidget {
  const SelectProductsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SelectProductsPageState();
}

enum LayoutProduct {
  listSmallCard,
  listBigCard,
  gridColumn2,
  gridColumn3
}

class SelectProductsPageState extends ConsumerState<SelectProductsPage>{
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
    final controller = ref.watch(productControllerProvider);
    final cart = ref.watch(productCartControllerProvider);
    final type = MyDevice.getType(context);

    final isSearchOpen = ref.watch(isSearchOpenProvider);

    return controller.when(
        error: (error, stack) => ErrorPage(
          exception: error is AppException
            ? error
            : AppException.errorUnexpected(error.toString()),
        ),
        loading: () => Scaffold(
          body: GridViewColumnSkeleton(),
        ),
        data: (products) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Catálago"),
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
                // IconButton(
                //   onPressed: () {
                //     showModalBottomSheet(
                //       context: context,
                //       builder: (context) => DraggableFilterProduct()
                //     );
                //   },
                //   icon: Icon(Icons.filter_alt)
                // ),
                IconButton(
                  onPressed: _toggleSearch,
                  icon: Icon(isSearchOpen ? Icons.close : Icons.search),
                ),
              ],
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

                  Flexible(
                    child: MasonryGridView.builder(
                      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      padding: const EdgeInsets.all(14),
                      physics: const AlwaysScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      cacheExtent: 900,
                      itemCount: products.length,
                      itemBuilder: (context, i) {
                        final product = products[i];
                        final salesOrderProduct = cart[product.productId];

                        return SelectProductCard(
                          product: product,
                          salesOrderProduct: salesOrderProduct,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
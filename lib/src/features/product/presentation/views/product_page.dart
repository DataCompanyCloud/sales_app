import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/my_device.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/product/presentation/widgets/draggable/draggable_filter_product.dart';
import 'package:sales_app/src/features/product/presentation/widgets/draggable/draggable_layout_product.dart';
import 'package:sales_app/src/features/product/presentation/widgets/layouts/grid_view_column.dart';
import 'package:sales_app/src/features/product/presentation/widgets/skeleton/grid_view_column_skeleton.dart';
import 'package:sales_app/src/features/product/providers.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProductPageState();
}

enum LayoutProduct {
  listSmallCard,
  listBigCard,
  gridColumn2,
  gridColumn3
}

class ProductPageState extends ConsumerState<ProductPage>{
  final productIndexProvider = StateProvider<int>((ref) => 0);
  final isSearchOpenProvider = StateProvider<bool>((_) => false);
  final searchQueryProvider = StateProvider<String>((_) => '');
  final _searchController = TextEditingController();

  LayoutProduct layoutProduct = LayoutProduct.gridColumn2;

  void updateLayout(LayoutProduct layout) {
    layoutProduct = layout;
  }

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
    final currentIndex = ref.watch(productIndexProvider);

    final type = MyDevice.getType(context);

    if (type == DeviceType.mobile) {
      print("Celular");
    }

    if (type == DeviceType.tablet) {
      print("Tablet");
    }

    final isSearchOpen = ref.watch(isSearchOpenProvider);

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => GridViewColumnSkeleton(),
      data: (products) {
        if(products.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Produtos"),
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
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_rounded,
                      size: 96,
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    Text("Nenhum produto para ser mostrado"),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    InkWell(
                      onTap: () => ref.refresh(productControllerProvider.future),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Tentar novamente", style: TextStyle(color: Colors.blue),),
                      )
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
          );
        }
        return Scaffold(
          //extendBody: true,
          appBar: AppBar(
            title: Text("Produtos"),
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
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => DraggableFilterProduct()
                  );
                },
                icon: Icon(Icons.filter_alt)
              ),
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
                  child: GridViewColumn(products: products),
                ),
                // Flexible(
                //   child: switch(layoutProduct) {
                //     LayoutProduct.listSmallCard => ListViewColumnSmall(products: products),
                //     LayoutProduct.listBigCard => ListViewColumnBig(products: products),
                //     LayoutProduct.gridColumn2 => GridViewColumn2(products: products),
                //     LayoutProduct.gridColumn3 => GridViewColumn3(products: products),
                //   },
                // ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
        );
      }
    );
  }
}
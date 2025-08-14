import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/my_device.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/features/product/presentation/widgets/draggable/draggable_layout_product.dart';
import 'package:sales_app/src/features/product/presentation/widgets/skeleton/grid_view_column_2_skeleton.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => GridViewColumn2Skeleton(),
      data: (products) {
        if(products.isEmpty) {
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
                    Text("Nenhum cliente para ser mostrado"),
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
                Flexible(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 0.8,
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    children: List.generate(products.length, (index) {
                      final product = products[index];
                      final image = product.images.firstOrNull;
                      final imageUrl = image?.url;

                      return GestureDetector(
                        onTap: () {
                          context.pushNamed(ProductRouter.productDetails.name, extra: product);
                        },
                        child: Container(
                          child: Text("${product.name}",
                          overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      );

                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: colorScheme.tertiary, width: 2)
                        ),
                        child: InkWell(
                          onTap: () {
                            // context.pushNamed(ProductRouter.productDetails.name, extra: product);
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
                                        child:
                                        imageUrl == null
                                            ? Image.asset(
                                          'assets/images/not_found.png',
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.network(imageUrl)
                                        ,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "R\$${product.price}",
                                        style: TextStyle(color: colorScheme.onSurface),
                                      ),
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          color: colorScheme.onSurface,
                                          overflow: TextOverflow.ellipsis,
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
                  ),
                )
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
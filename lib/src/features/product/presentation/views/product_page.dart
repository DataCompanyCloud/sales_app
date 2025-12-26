import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/features/product/presentation/widgets/card/product_card.dart';
import 'package:sales_app/src/features/product/presentation/widgets/card/product_details_card.dart';
import 'package:sales_app/src/features/product/presentation/widgets/draggable/draggable_filter_product.dart';
import 'package:sales_app/src/features/product/presentation/widgets/skeleton/grid_view_column_skeleton.dart';
import 'package:sales_app/src/features/product/providers.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => ProductPageState();
}


class ProductPageState extends ConsumerState<ProductPage>{
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _scrollController = ScrollController();
  final _isSearchOpenProvider = StateProvider<bool>((_) => false);
  final _crossAxisCountProvider = StateProvider<double>((_) => 2);
  // double? _draftSliderValue; // valor temporário enquanto arrasta


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }


  void _onScroll() {
    // 1) Evita crash quando o controller ainda não está anexado
    if (!_scrollController.hasClients) return;

    // 2) Pega o estado atual do controller (Riverpod)
    final state = ref.read(productControllerProvider).valueOrNull;
    if (state == null) return;

    // 3) Guardas para paginação
    if (!state.hasMore) return;
    if (state.isLoadingMore) return;

    final position = _scrollController.position;

    // Evita disparar quando não dá pra scrollar (ex.: lista curta)
    if (!position.hasContentDimensions) return;

    const threshold = 200.0;
    final remaining = position.maxScrollExtent - position.pixels;

    if (remaining <= threshold) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    await ref.read(productControllerProvider.notifier).loadMore();
  }

  void _toggleSearch() {
    final isOpen = ref.read(_isSearchOpenProvider.notifier);
    isOpen.state = !isOpen.state;
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(productFilterProvider);
    final controller = ref.watch(productControllerProvider);
    final isSearchOpen = ref.watch(_isSearchOpenProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // final device = MyDevice.getType(context);
    // final isMobile = device == DeviceType.mobile;

    // final min = isMobile ? 1.0 : 1.0;
    // final max = isMobile ? 4.0 : 8.0;

    final columns = ref.watch(_crossAxisCountProvider);
    // final sliderValue = (_draftSliderValue ?? columns.toDouble())
    //     .clamp(min.toDouble(), max.toDouble());

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => Scaffold(
        body: GridViewColumnSkeleton(),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
      ),
      data: (pagination) {
        final products = pagination.items;

        return Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            actions: [
              // IconButton(
              //   onPressed: () {
              //     showModalBottomSheet(
              //       context: context,
              //       builder: (context) => DraggableLayoutProduct()
              //     );
              //   },
              //   icon: Icon(Icons.remove_red_eye)
              // ),
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
              if (controller.isLoading) {
                return Future.value();
              }

              return ref.refresh(productControllerProvider);
            },
            child: Column(
              children: [
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  onEnd: () {
                    if (isSearchOpen) {
                      FocusScope.of(context).requestFocus(_searchFocusNode);
                    }
                  },
                  child: isSearchOpen
                    ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: "Pesquisar...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSubmitted: (value) {
                          ref.read(productFilterProvider.notifier).state = filter.copyWith(
                              start: 0,
                              q: value
                          );

                          _searchFocusNode.unfocus();
                          _toggleSearch();
                        },
                      ),
                    ) : SizedBox.shrink(),
                  ),
                // SizedBox(
                //   width: double.infinity,
                //   child: Slider(
                //     value: columns,
                //     min: min,
                //     max: max,
                //     divisions: (max - min).toInt(),
                //     label: '${sliderValue.round()} colunas',
                //     onChanged: (v) {
                //       // setState(() {
                //       //   if (isMobile) {
                //       //     _columnsMobile = v.round();
                //       //   } else {
                //       //     _columnsDesktop = v.round();
                //       //   }
                //       // });
                //       // setState(() => _draftSliderValue = v);
                //       // comita no Riverpod ao soltar
                //       final newCols = v.round().clamp(min, max);
                //       ref.read(_crossAxisCountProvider.notifier).state = newCols.toDouble();
                //       setState(() => _draftSliderValue = null);
                //
                //     },
                //     onChangeEnd: (v) {
                //       // comita no Riverpod ao soltar
                //       final newCols = v.round().clamp(min, max);
                //       ref.read(_crossAxisCountProvider.notifier).state = newCols.toDouble();
                //       setState(() => _draftSliderValue = null);
                //     },
                //   ),
                // ),
                Expanded(
                  child:
                    products.isEmpty
                    ? Center(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_rounded,
                              size: 96,
                            ),
                            SizedBox(height: 12),
                            Text("Nenhum produto para ser mostrado."),
                            SizedBox(height: 16),
                            InkWell(
                                onTap: () => ref.refresh(productControllerProvider.future),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text("Tentar novamente", style: TextStyle(color: scheme.primary)),
                                )
                            ),
                          ],
                        ),
                      ),
                    )
                    : Stack(
                      children: [
                        MasonryGridView.builder(
                          controller: _scrollController,
                          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns.toInt(),
                          ),
                          padding: const EdgeInsets.all(14),
                          physics: const AlwaysScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          cacheExtent: 900,
                          itemCount: products.length,
                          itemBuilder: (context, i) {
                            final product = products[i];

                            return Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed(ProductRouter.productDetails.name, extra: product);
                                },
                                child: 
                                columns > 1    
                                  ? ProductCard(product: product)
                                  : ProductDetailsCard(product: product)
                                ,
                              ),
                            );
                          },
                        ),
                        pagination.isLoadingMore
                          ? SafeArea(
                            top: false,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: scheme.outline, width: 2)
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: const CircularProgressIndicator(strokeWidth: 2.4),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Carregando mais produtos...',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          : SizedBox.shrink(),
                      ],
                    ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
        );
      }
    );
  }
}
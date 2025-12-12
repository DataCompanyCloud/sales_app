// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
// import 'package:sales_app/src/features/product/presentation/widgets/card/product_card.dart';
//
// class ProductsGrid extends ConsumerStatefulWidget {
//   const ProductsGrid({super.key});
//
//   @override
//   ConsumerState<ProductsGrid> createState() => _ProductsGridState();
// }
//
// class _ProductsGridState extends ConsumerState<ProductsGrid> {
//
//   final _scrollController = ScrollController();
//   bool _isLoadingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (!_scrollController.hasClients) return;
//
//     final position = _scrollController.position;
//
//     // margem de segurança de 200px antes do final
//     const threshold = 200;
//
//     final isNearBottom =
//         position.pixels >= position.maxScrollExtent - threshold;
//
//     if (isNearBottom && !_isLoadingMore) {
//       _loadMoreProducts();
//     }
//   }
//
//   Future<void> _loadMoreProducts() async {
//     setState(() => _isLoadingMore = true);
//
//     try {
//       // chama seu usecase/repository para buscar mais produtos
//       // await context.read<ProductsCubit>().loadMore();
//     } finally {
//       if (mounted) {
//         setState(() => _isLoadingMore = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final products = context.watch<ProductsCubit>().state.products;
//     // final device = DeviceType.mobile; // só exemplo
//
//     return Flexible(
//       child: MasonryGridView.builder(
//         controller: _scrollController, // <<< AQUI
//         gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//         ),
//         padding: const EdgeInsets.all(14),
//         physics: const AlwaysScrollableScrollPhysics(),
//         mainAxisSpacing: 12,
//         crossAxisSpacing: 12,
//         cacheExtent: 900,
//         itemCount: products.length,
//         itemBuilder: (context, i) {
//           final product = products[i];
//           final image = product.images.firstOrNull;
//
//           return Card(
//             margin: EdgeInsets.zero,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             clipBehavior: Clip.antiAlias,
//             child: InkWell(
//               onTap: () {
//                 context.pushNamed(
//                   ProductRouter.productDetails.name,
//                   extra: product,
//                 );
//               },
//               child: ProductCard(product: product),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

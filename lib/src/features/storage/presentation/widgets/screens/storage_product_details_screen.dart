import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/cards/storage_product_details_card.dart';
import 'package:sales_app/src/features/storage/providers.dart';

// class StorageProductDetailsScreen extends ConsumerStatefulWidget {
//   final int storageId;
//
//   const StorageProductDetailsScreen({
//     super.key,
//     required this.storageId
//   });
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => StorageProductDetailsScreenState();
// }
//
// class StorageProductDetailsScreenState extends ConsumerState<StorageProductDetailsScreen>{
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = ref.watch(storageProductsProvider(widget.storageId));
//
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//         child: controller.when(
//           error: (error, stack) => ErrorPage(
//             exception: error is AppException
//               ? error
//               : AppException.errorUnexpected(error.toString()),
//           ),
//           loading: () => Center(
//             child: CircularProgressIndicator(),
//           ),
//           data: (products) {
//             return ListView.builder(
//               itemCount: products.length,
//               itemBuilder: (context, i) {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 4),
//                   child: StorageProductDetailsCard(product: products[i]),
//                 );
//               }
//             );
//           },
//         )
//       ),
//     );
//   }
// }


class StorageProductDetailsScreen extends ConsumerWidget {
  final int storageId;

  const StorageProductDetailsScreen({
    super.key,
    required this.storageId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(storageProductsProvider(storageId));

    return controller.when(
      error: (error, stack) => Text("ERROR: ${error.toString()}"),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (products) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          itemCount: products.length,
          itemBuilder: (context, i) {
            final product = products[i];

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: StorageProductDetailsCard(product: product),
            );
          }
        );
      }
    );
  }
}
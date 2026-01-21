import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/storage/presentation/widgets/cards/storage_product_details_card.dart';
import 'package:sales_app/src/features/storage/providers.dart';

class StorageProductDetailsScreen extends ConsumerWidget {
  final int storageId;

  const StorageProductDetailsScreen({
    super.key,
    required this.storageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(storageProductsControllerProvider(storageId));

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      data: (pagination) {
        final products = pagination.items;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) {
                final product = products[i];

                return StorageProductDetailsCard(product: product);
              }
            ),
          ),
        );
      }
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsSkeleton extends ConsumerWidget {
  const ProductDetailsSkeleton({super.key});

  /// TODO: Finalizar skeleton de product_details
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Skeletonizer(
      enabled: true,
      child: Container()
    );
  }
}
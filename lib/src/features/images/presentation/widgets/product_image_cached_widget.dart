import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/images/presentation/controllers/valueObjects/product_image_cached.dart';
import 'package:sales_app/src/features/images/providers.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';

class ProductImageCachedWidget extends ConsumerWidget {
  final int productId;
  final ImageEntity? image;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImageCachedWidget({
    super.key,
    required this.productId,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (image == null) {
      return _buildFallback();
    }

    if (image?.localUrl != null) {
      final localUrl = image?.localUrl;
      if (localUrl != null && localUrl.isNotEmpty) {
        return Image.file(
          File(localUrl),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => _buildFallback(),
        );
      }
    }

    final asyncImage = ref.watch(productImageCachedProvider(ProductImageCached(productId: productId, image: image!)));

    return asyncImage.when(
      error: (err, stack) => _buildFallback(),
      loading: () => _buildFallback(),
      data: (resolved) {
        // Se temos localUrl válida → usa arquivo
        final localUrl = resolved.localUrl;
        if (localUrl != null && localUrl.isNotEmpty) {
          return Image.file(
            File(localUrl),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, _, _) => _buildFallback(),
          );
        }

        // Não tem local, mas estamos online (caso extremo: download falhou)
        return Image.network(
          resolved.url,
          width: width ?? 160,
          height: height ?? 160,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return _buildFallback();
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildFallback();
          },
        );
      },
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      width: width ?? 160,
      height: height ?? 160,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildFallback() {
    return SizedBox(
      width: width ?? 160,
      height: height ?? 160,
      child: Image.asset(
        'assets/images/not_found.png',
        fit: fit,
      ),
    );
  }
}

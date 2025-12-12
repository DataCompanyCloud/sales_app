import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';

class ImageWidget extends ConsumerWidget {
  final ImageEntity? image; // pode vir só o path ou URL completa
  final double? width;
  final double? height;
  final BoxFit fit;

  const ImageWidget({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnecting = ref.watch(isConnectedProvider);
    final img = image;

    // Sem imagem → fallback
    if (img == null) {
      return _buildFallback();
    }

    // 1) Tenta usar arquivo local, se tiver um path válido
    final localUrl = img.localUrl;
    if (localUrl != null && localUrl.isNotEmpty) {
      return Image.file(
        File(localUrl),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }


    if (!isConnecting) {
      return _buildFallback();
    }


    // 2) Caso contrário, usa a URL remota
    return Image.network(
      img.url,
      width: width ?? 160,
      height: height ?? 160,
      fit: fit,
      // enquanto estiver carregando
      loadingBuilder: (context, child, loadingProgress) {
        print("carregando: ${loadingProgress}");
        if (loadingProgress == null) {
          // já carregou → mostra a imagem
          return child;
        }

        // ainda carregando → mostra algo visual
        return _buildLoading();
      },
      // se der erro ao carregar a imagem remota
      errorBuilder: (context, error, stackTrace) {
        print("error");
        return _buildFallback();
      },
    );
  }

  /// Placeholder de "carregando"
  Widget _buildLoading() {
    return SizedBox(
      width: width ?? 160,
      height: height ?? 160,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  /// Placeholder de erro / sem imagem
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';


class ImageWidget extends ConsumerStatefulWidget {
  final ImageEntity? image;      // pode vir só o path ou URL completa
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
  ConsumerState<ConsumerStatefulWidget> createState() => ImageWidgetState();
}

class ImageWidgetState extends ConsumerState<ImageWidget>{
  @override
  Widget build(BuildContext context) {
    final image = widget.image;

    if (image == null) {
      return _buildFallback();
    }

    final double? width = widget.width;
    final double? height = widget.height;
    final BoxFit fit = widget.fit;

    final localUrl = image.localUrl;
    if (localUrl != null) {
      return Image.asset(
        localUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    // se não tiver path, já cai no fallback
    return Image.network(
      image.url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (_, _, _) => _buildFallback(),
      errorBuilder: (_, _, _) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Image.asset(
      'assets/images/not_found.png',
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}
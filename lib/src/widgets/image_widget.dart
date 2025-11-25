import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ImageWidget extends ConsumerStatefulWidget {
  final String? path;      // pode vir só o path ou URL completa
  final double? width;
  final double? height;
  final BoxFit fit;

  const ImageWidget({
    super.key,
    required this.path,
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
    final String? path = widget.path;
    final double? width = widget.width;
    final double? height = widget.height;
    final BoxFit fit = widget.fit;

    // se não tiver path, já cai no fallback
    if (path == null || path.trim().isEmpty) {
      return Image.asset(
        'assets/images/not_found.png',
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Image.network(
      path,
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
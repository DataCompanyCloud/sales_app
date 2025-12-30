import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ImageDialog extends ConsumerWidget {
  final String image;

  const ImageDialog({
    super.key,
    required this.image
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Center(
                child: Image.network(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            top: 16,
            right: 16,
            child: IconButton.filled(
              onPressed: () => context.pop(),
              style: IconButton.styleFrom(
                backgroundColor: scheme.primary
              ),
              icon: Icon(Icons.close, color: scheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
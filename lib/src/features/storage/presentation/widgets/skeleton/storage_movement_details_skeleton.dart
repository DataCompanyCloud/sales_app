import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorageMovementDetailsSkeleton extends ConsumerWidget {
  const StorageMovementDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Estoque"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 40),
          child: Skeletonizer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Bone.text(
                  fontSize: 16,
                  width: 86,
                  textAlign: TextAlign.center,
                  borderRadius: BorderRadius.circular(8),
                ),
                Bone.text(
                  fontSize: 16,
                  width: 86,
                  textAlign: TextAlign.center,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SalesOrderCreatePageSkeleton extends ConsumerWidget {
  const SalesOrderCreatePageSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Skeletonizer(
          child: Bone.text(
            fontSize: 16,
            width: 86,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        actions: [
          Skeletonizer(
            child: Bone.iconButton(
              size: 24,
              indentEnd: 10,
            ),
          )
        ],
      ),
      body: Skeletonizer(
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
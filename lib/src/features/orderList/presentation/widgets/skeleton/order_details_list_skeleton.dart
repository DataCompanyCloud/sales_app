import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailsListSkeleton extends ConsumerWidget {
  const OrderDetailsListSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Skeletonizer(
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            itemCount: 12,
            padding: EdgeInsets.symmetric(horizontal: 18),
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Bone.text(
                              fontSize: 48,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 4, right: 4),
                            child: Bone.text(
                              width: 32,
                              fontSize: 28,
                              borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Bone.text(
                      width: 48,
                      fontSize: 32,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ),
    );
  }
}
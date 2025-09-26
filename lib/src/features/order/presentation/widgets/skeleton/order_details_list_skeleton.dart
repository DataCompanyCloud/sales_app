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
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12, bottom: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Bone.button(
                      width: 52,
                      height: 52,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 12,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Bone.text(
                              fontSize: 48,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Bone.text(
                                        width: 38,
                                        fontSize: 28,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsets.only(left: 4, right: 4),
                                        child: Bone.text(
                                          width: 38,
                                          fontSize: 28,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: Bone.text(
                                      width: 52,
                                      fontSize: 28,
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
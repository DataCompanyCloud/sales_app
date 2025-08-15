import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/my_device.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GridViewColumn2Skeleton extends ConsumerWidget {
  const GridViewColumn2Skeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final device = MyDevice.getType(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
        actions: [
          Skeletonizer(
            effect: ShimmerEffect(
              highlightColor: Colors.white,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Bone.iconButton(size: 40)
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Bone.iconButton(size: 40)
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 6),
                  child: Bone.iconButton(size: 40)
                )
              ],
            )
          )
        ],
      ),
      body: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Skeletonizer(
                enabled: true,
                child: GridView.count(
                  crossAxisCount: device == DeviceType.mobile
                      ? 2
                      : 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  children: List.generate(20, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        // border: Border.all(color: colorScheme.tertiary, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                color: Colors.grey.shade300,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Skeleton.leaf(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: ColoredBox(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            padding: EdgeInsets.only(left: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Bone.text(width: 80),
                                Padding(padding: EdgeInsets.only(top: 6)),
                                Bone.text(width: 160),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                )
              )
            )
          ],
        )
      ),
    );
  }
}
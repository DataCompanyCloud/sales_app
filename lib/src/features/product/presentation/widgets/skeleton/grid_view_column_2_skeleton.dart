import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GridViewColumn2Skeleton extends ConsumerWidget {
  const GridViewColumn2Skeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text("Catálogo de Produtos"),
        /*
        Align(
          alignment: Alignment.centerLeft,
          child: Transform.scale(
            scale: 0.5,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
        */
        leading: IconButton(
          onPressed: () {

          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
      ),
      body: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 90,
                    height: 45,
                    child: Bone.button(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 90,
                    height: 45,
                    child: Bone.button(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Skeletonizer(
                enabled: true,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  children: List.generate(6, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: colorScheme.tertiary, width: 2),
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
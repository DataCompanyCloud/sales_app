import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorageListSkeleton extends ConsumerWidget {
  const StorageListSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Estoques"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: scheme.outline,
            height: 1.0,
          ),
        ),
        actions: [
          Skeletonizer(
            effect: ShimmerEffect(
              highlightColor: Colors.white,
              baseColor: scheme.surface
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Bone.iconButton(size: 40)
            ),
          ),
        ],
      ),
      body: Skeletonizer(
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.star, size: 38),
                      title: Bone.text(width: 120),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: const Icon(Icons.person, size: 38),
                              title: Bone.text(width: 200),
                              trailing: const Icon(Icons.arrow_forward),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }

}
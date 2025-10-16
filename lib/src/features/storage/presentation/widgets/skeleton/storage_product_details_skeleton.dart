import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorageProductDetailsSkeleton extends ConsumerWidget {
  const StorageProductDetailsSkeleton({super.key});

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
      body: Skeletonizer(
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.shopping_cart, size: 38),
                            title: Bone.text(width: 200),
                            trailing: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ),
                    );
                  }
                )
              )
            ],
          ),
        )
      ),
    );
  }
}
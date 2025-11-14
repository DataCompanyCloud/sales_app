import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SalesOrderDetailsCardSkeleton extends ConsumerWidget {
  const SalesOrderDetailsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.person, size: 38),
                          title: Bone.text(width: 200),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Bone.text(width: double.infinity, fontSize: 15),
                              SizedBox(height: 4),
                              Bone.text(width: 80, fontSize: 15),
                              SizedBox(height: 4),
                              Bone.text(width: 100, fontSize: 15),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  );
                }),
            ),
          ],
        )
      ),
    );
  }
}
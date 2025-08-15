import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerPageSkeleton extends ConsumerWidget {

  const CustomerPageSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 6),
            child: Bone.button(
              width: 250,
              borderRadius: BorderRadius.circular(10),
            )
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Item number $index as title'),
                        subtitle: const Text('Subtitle here'),
                        trailing: const Icon(Icons.ac_unit),
                      ),
                    ),
                  ),
                );
              }),
          ),
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerPageSkeleton extends ConsumerWidget {

  const CustomerPageSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Transform.scale(
            scale: 0.5,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.goNamed(HomeRouter.home.name);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
      ),
      body: Skeletonizer(
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
                itemCount: 10,
                itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Item number $index as title'),
                      subtitle: const Text('Subtitle here'),
                      trailing: const Icon(Icons.ac_unit),
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
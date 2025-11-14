import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderPageSkeleton extends ConsumerWidget {
  const OrderPageSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Pedidos"),
          leading: IconButton(
            onPressed: () {
              context.goNamed(HomeRouter.home.name);
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 22),
          )
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
                height: 40,
                borderRadius: BorderRadius.circular(10),
              )
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.person, size: 38),
                          title: Bone.text(width: 250),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Bone.text(width: 250, fontSize: 15),
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
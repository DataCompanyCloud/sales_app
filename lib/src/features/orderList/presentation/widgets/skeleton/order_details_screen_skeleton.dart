import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailsScreenSkeleton extends ConsumerWidget {
  const OrderDetailsScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Skeletonizer(
        enabled: true,
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Bone.text(
                        width: 90,
                        fontSize: 28
                      ),
                      Bone.button(
                        width: 90,
                        height: 32,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Bone.text(
                    width: 120,
                    fontSize: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Card(
                      elevation: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("INFORMAÇÕES DO CLIENTE"),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Divider(
                                  thickness: 1.5,
                                ),
                              ),
                              Bone.text(width: 240, fontSize: 15),
                              SizedBox(height: 4),
                              Bone.text(width: 200, fontSize: 15),
                              SizedBox(height: 4),
                              Bone.text(width: 180, fontSize: 15)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Card(
                      elevation: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("INFORMAÇÕES DO PEDIDO"),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Divider(
                                  thickness: 1.5,
                                ),
                              ),
                              Bone.text(width: 240, fontSize: 15),
                              SizedBox(height: 4),
                              Bone.text(width: 180, fontSize: 15),
                              SizedBox(height: 4),
                              Bone.text(width: 200, fontSize: 15)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "Pagamento",
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Bone.text(width: 120),
                                SizedBox(height: 4),
                                Bone.text(width: 120),
                                SizedBox(height: 4),
                                Bone.text(width: 120),
                                SizedBox(height: 4),
                                Bone.text(width: 120),
                              ],
                            ),
                            Column(
                              children: [
                                Bone.text(width: 40),
                                SizedBox(height: 4),
                                Bone.text(width: 40),
                                SizedBox(height: 4),
                                Bone.text(width: 40),
                                SizedBox(height: 4),
                                Bone.text(width: 40),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
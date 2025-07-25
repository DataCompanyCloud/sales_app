import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerDetailsSkeleton extends ConsumerWidget {

  const CustomerDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        leading: Icon(Icons.arrow_back_ios_new, size: 22)
      ),
      body: Skeletonizer(
        enabled: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 75),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                Bone.circle(size: 100),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: List.generate(3, (i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Card(
                          elevation: 1,
                          margin: EdgeInsets.all(2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Bone.text(
                                  width: 180,
                                  fontSize: 20,
                                ),
                              ),
                              Column(
                                children: List.generate(2, (i) {
                                  return ListTile(
                                    title: Bone.text(width: 100),
                                    subtitle: Bone.text(width: 80),
                                    trailing: Bone.text(width: 50, fontSize: 24),
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
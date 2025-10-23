import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePageSkeleton extends ConsumerWidget {
  const HomePageSkeleton({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Início"),
        centerTitle: true,
        leading: Bone.iconButton(),
        actions: [
          Skeletonizer(
            effect: ShimmerEffect(
              highlightColor: Colors.white,
              baseColor: scheme.surface
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Bone.iconButton(size: 40),
            ),
          ),
        ],
      ),
      body: Skeletonizer(
        enabled: true,
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(
                  color: scheme.secondary,
                  width: 1
                ),
              ),
              color: scheme.surface,
              margin: EdgeInsets.all(2),
              child: ListTile(
                visualDensity: VisualDensity(vertical: 3),
                leading: Bone.icon(size: 24),
                title: Bone.text(fontSize: 16),
                subtitle: Bone.text(fontSize: 15),
                trailing: Bone.iconButton(size: 20),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 16)),
            Card(
              color: scheme.surface,
              elevation: 3,
              margin: EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Bone.text(fontSize: 20, width: 60),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 12)),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: Bone.icon(size: 24),
                    title: Bone.text(width: double.infinity, fontSize: 15),
                    trailing: Bone.icon(size: 24),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: Bone.icon(size: 24),
                    title: Bone.text(width: double.infinity, fontSize: 15),
                    trailing: Bone.icon(size: 24),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: Bone.icon(size: 24),
                    title: Bone.text(width: double.infinity, fontSize: 15),
                    trailing: Bone.icon(size: 24),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 12)),
            Card(
              color: scheme.surface,
              elevation: 3,
              margin: EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Bone.text(fontSize: 20, width: 60),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 12)),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: Bone.icon(size: 24),
                    title: Bone.text(width: double.infinity, fontSize: 15),
                    trailing: Bone.icon(size: 24),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: Bone.icon(size: 24),
                    title: Bone.text(width: double.infinity, fontSize: 15),
                    trailing: Bone.icon(size: 24),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: Bone.icon(size: 24),
                    title: Bone.text(width: double.infinity, fontSize: 15),
                    trailing: Bone.icon(size: 24),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
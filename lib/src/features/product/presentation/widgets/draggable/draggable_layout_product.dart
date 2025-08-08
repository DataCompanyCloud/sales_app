import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_controller_old.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_providers.dart';

class DraggableLayoutProduct extends ConsumerWidget {

  const DraggableLayoutProduct({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(productViewModelProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  "Modos de Exibição",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 12)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.view_list_rounded),
                    title: Text("Lista 1"),
                    onTap: () {
                      viewModel.updateLayout(LayoutProduct.listSmallCard);
                      context.pop();
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.view_agenda),
                    title: Text("Lista 2"),
                    onTap: () {
                      viewModel.updateLayout(LayoutProduct.listBigCard);
                      context.pop();
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.grid_view_rounded),
                    title: Text("Grade 1"),
                    onTap: () {
                      viewModel.updateLayout(LayoutProduct.gridColumn2);
                      context.pop();
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.apps_rounded),
                    title: Text("Grade 2"),
                    onTap: () {
                      viewModel.updateLayout(LayoutProduct.gridColumn3);
                      context.pop();
                    }
                  ),
                )
              ]
            ),
          ),
        );
      }
    );
  }
}
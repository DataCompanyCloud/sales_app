import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductStockPage extends ConsumerWidget {
  const ProductStockPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Estoque de Produtos"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.search)
          )
        ],
      ),
      body: SafeArea(
        child: Expanded(
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.onTertiary, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 8),
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                color: Colors.grey
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nome do Produto"),
                              Text("Qtd. em Estoque")
                            ],
                          ),
                        ),
                      ) 
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
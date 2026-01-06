import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';

class SalesOrdersHistoryPage extends ConsumerWidget {
  const SalesOrdersHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de Pedidos"),
        leading: IconButton(
          onPressed: () {
            context.goNamed(AppRoutes.home.name);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search)
          ),
        ],
      ),
      body: Center(),
    );
  }
}
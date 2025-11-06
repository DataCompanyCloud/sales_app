import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/stockTransaction/presentation/widgets/cards/transaction_card.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de Transações"),
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
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4),
          itemCount: 12,
          itemBuilder: (context, index) {
            return TransactionCard();
          }
        ),
      ),
    );
  }
}
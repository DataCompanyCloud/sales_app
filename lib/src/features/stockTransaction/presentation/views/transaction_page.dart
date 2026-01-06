import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction_item.dart';
import 'package:sales_app/src/features/stockTransaction/domain/valueObjects/transaction_type.dart';
import 'package:sales_app/src/features/stockTransaction/presentation/widgets/cards/transaction_card.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final transactions = genStockTransactions(20);
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
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: TransactionCard(
                stockTransaction: transaction,
              ),
            );
          }
        ),
      ),
    );
  }
}


List<StockTransaction> genStockTransactions (int max) {

  List<StockTransaction> output = [];
  for (int i=0; i< max; i++) {

    output.add(
      StockTransaction(
        id: i+1,
        code: (i+1).toString().padLeft(5, "0"), // 1 => "00001"
        createAt: DateTime.now(),
        type: random.element([TransactionType.stockIn, TransactionType.stockOut, TransactionType.transfer]),
        items: genItems(),
        orderId: random.boolean() ? random.integer(1000, min: 1) : null,
        // toStorage: random.boolean() ? random.integer(5, min: 1) : null,
        // fromStorage: random.boolean() ? random.integer(5, min: 1) : null,
        serverId: random.boolean() ? random.integer(1000, min: 1) : null, // Simboliza se ele está sincronizado com a nuvem
        // userId
        // description
      )
    );
  }

  return output;
}

List<StockTransactionItem> genItems() {
  List<StockTransactionItem> output = [];

  return output;
}
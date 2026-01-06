import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction.dart';

enum TypeT {
  mySales,
  sales,
  transfer
}

class TransactionCard extends ConsumerWidget {
  final StockTransaction stockTransaction;

  const TransactionCard({
    super.key,
    required this.stockTransaction
  });

  TypeT getType() {
    final fromId = stockTransaction.fromStorage;
    final toId = stockTransaction.toStorage;
    final salesId = stockTransaction.orderId;

    if (fromId == toId && salesId != null) {
      return TypeT.mySales;
    }

    // if (toId == 2 && salesId != null) {
    //   return "Devolução";
    // }

    if (salesId != null) {
      return TypeT.sales;
    }

    return TypeT.transfer;
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final type = getType();

    final date = stockTransaction.createAt;
    final formatter = DateFormat('dd/MM/yy HH:mm', 'pt-BR');
    final formattedDate = formatter.format(date);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline, width: 2)
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
                    width: 75,
                    height: 20,
                    decoration: BoxDecoration(
                      color: type == TypeT.sales ? scheme.tertiary
                          : type == TypeT.mySales ? scheme.tertiary
                          : scheme.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      stockTransaction.code,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    width: 75,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10)
                      ),
                        color: type == TypeT.sales ? scheme.tertiary
                            : type == TypeT.mySales ? scheme.tertiary
                            : scheme.primary
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                      child: Icon(
                        type == TypeT.sales ? Icons.download_sharp
                            : type == TypeT.mySales ? Icons.download_sharp
                            : Icons.compare_arrows
                        ,
                        color: scheme.onSurface,
                        size: 38,
                      ),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: type == TypeT.sales ? scheme.tertiary
                                    : type == TypeT.mySales ? scheme.tertiary
                                    : scheme.primary
                                ),
                                child: Text(
                                  type == TypeT.sales ? "Venda"
                                      : type == TypeT.mySales ? "Minha Venda"
                                      : "Transferência"
                                  ,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: Row(
                                  children: [
                                    Icon(
                                      type == TypeT.transfer
                                        ? Icons.unarchive
                                        : Icons.archive
                                      ,
                                      color: type == TypeT.transfer
                                        ? scheme.primary
                                        : scheme.tertiary,
                                      size: 18
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      random.integer(100, min: 1).toString().padLeft(2, "0"),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: type == TypeT.transfer
                                          ? scheme.primary
                                          : scheme.tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: scheme.onSurfaceVariant
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 18),
                              //   child: Text(
                              //     "R\$$price",
                              //     style: TextStyle(
                              //       fontSize: 15,
                              //       // fontWeight: FontWeight.bold,
                              //       color: isActive ? Colors.greenAccent : Colors.redAccent
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
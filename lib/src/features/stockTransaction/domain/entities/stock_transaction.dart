import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/owner_transaction.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction_item.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/storage_endpoint.dart';
import 'package:sales_app/src/features/stockTransaction/domain/valueObjects/transaction_type.dart';

part 'stock_transaction.freezed.dart';
part 'stock_transaction.g.dart';

@freezed
abstract class StockTransaction with _$StockTransaction {
  const StockTransaction._();

  const factory StockTransaction.raw({
    required int id,      // id local
    required String uuid,
    required String code,
    OwnerTransaction? owner,
    String? description,
    int? orderId,              // Link com um pedido
    required DateTime createdAt,
    required TransactionType type,
    StorageEndpoint? fromStorage,
    StorageEndpoint? toStorage,
    required List<StockTransactionItem> items,
  }) = _StockTransaction;

  /// TODO: Fazer as validações
  factory StockTransaction ({
    required int id,
    required String uuid,
    required String code,
    int? serverId,
    OwnerTransaction? owner,
    String? description,
    int? orderId,
    required DateTime createdAt,
    required TransactionType type,
    StorageEndpoint? fromStorage,
    StorageEndpoint? toStorage,
    required List<StockTransactionItem> items
  }) {

    return StockTransaction.raw(
      id: id,
      uuid: uuid,
      code: code,
      owner: owner,
      description: description,
      orderId: orderId,
      createdAt: createdAt,
      type: type,
      fromStorage: fromStorage,
      toStorage: toStorage,
      items: items
    );
  }

  factory StockTransaction.fromJson(Map<String, dynamic> json) =>
      _$StockTransactionFromJson(json);

}
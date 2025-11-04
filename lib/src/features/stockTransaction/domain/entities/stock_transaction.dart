import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction_item.dart';
import 'package:sales_app/src/features/stockTransaction/domain/valueObjects/transaction_source.dart';
import 'package:sales_app/src/features/stockTransaction/domain/valueObjects/transaction_type.dart';

part 'stock_transaction.freezed.dart';
part 'stock_transaction.g.dart';

@freezed
abstract class StockTransaction with _$StockTransaction {
  const StockTransaction._();

  const factory StockTransaction.raw({
    required int id,      // id local
    required String code,
    int? serverId,             // id do servidor
    int? userId,
    String? description,
    int? orderId,              // Link com um pedido
    required DateTime createAt,
    required TransactionType type,
    required TransactionSource source,
    int? fromStorageId,
    int? toStorageId,
    required List<StockTransactionItem> items,
  }) = _StockTransaction;

  factory StockTransaction ({
    required int id,
    required String code,
    int? serverId,
    int? userId,
    String? description,
    int? orderId,
    required DateTime createAt,
    required TransactionType type,
    required TransactionSource source,
    int? fromStorageId,
    int? toStorageId,
    required List<StockTransactionItem> items
  }) {
    /// TODO: Fazer as validações
    if (code.isEmpty) {
      AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "'Code' não pode ser nulo");
    }

    return StockTransaction.raw(
      id: id,
      code: code,
      serverId: serverId,
      userId: userId,
      description: description,
      orderId: orderId,
      createAt: createAt,
      type: type,
      source: source,
      fromStorageId: fromStorageId,
      toStorageId: toStorageId,
      items: items
    );
  }

  factory StockTransaction.fromJson(Map<String, dynamic> json) =>
      _$StockTransactionFromJson(json);
}
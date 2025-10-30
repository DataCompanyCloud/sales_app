import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_transaction_item.freezed.dart';
part 'stock_transaction_item.g.dart';

@freezed
abstract class StockTransactionItem with _$StockTransactionItem {
  const StockTransactionItem._();

  const factory StockTransactionItem.raw({
    required int id,      // id local
    required String code, // Sinc com o servidor
    int? serverId,
    int? movementId,
    required int productId,
    required String productCode,
    required String productName,
    required int quantity,
  }) = _StockTransactionItem;

  factory StockTransactionItem ({
    required int id,
    required String code,
    int? serverId,
    int? movementId,
    required int productId,
    required String productCode,
    required String productName,
    required int quantity
  }) {
    /// TODO: Fazer as validações quando as informações forem diferentes de null!

    return StockTransactionItem.raw(
      id: id,
      code: code,
      productId: productId,
      productCode: productCode,
      productName: productName,
      quantity: quantity
    );
  }

  factory StockTransactionItem.fromJson(Map<String, dynamic> json) =>
      _$StockTransactionItemFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/product/domain/entities/movement_item.dart';

part 'stock_movement.freezed.dart';
part 'stock_movement.g.dart';

enum MovementType {
  /// Entrada de estoque
  stockIn,
  /// Saída de estoque
  stockOut,
  /// Transferência entre estoques
  stockTransfer
}

@freezed
abstract class StockMovement with _$StockMovement {
  const StockMovement._();

  const factory StockMovement.raw({
    required int stockId,      // id local
    required String stockUuId, // Sinc com servidor
    int? serverId,             // id do servidor
    int? userId,
    String? description,
    int? orderId,              // Link com um pedido
    required DateTime createAt,
    required MovementType type,
    int? fromStorageId,
    int? toStorageId,
    required List<MovementItem> items,
  }) = _StockMovement;

  factory StockMovement ({
    required int stockId,
    required String stockUuId,
    int? serverId,
    int? userId,
    required String? description,
    int? orderId,
    required DateTime createAt,
    required MovementType type,
    int? fromStorageId,
    int? toStorageId,
    required List<MovementItem> items
  }) {
    /// TODO: Fazer as validações

    return StockMovement.raw(
      stockId: stockId,
      stockUuId: stockUuId,
      serverId: serverId,
      userId: userId,
      description: description,
      orderId: orderId,
      createAt: createAt,
      type: type,
      fromStorageId: fromStorageId,
      toStorageId: toStorageId,
      items: items
    );
  }

  factory StockMovement.fromJson(Map<String, dynamic> json) =>
      _$StockMovementFromJson(json);
}
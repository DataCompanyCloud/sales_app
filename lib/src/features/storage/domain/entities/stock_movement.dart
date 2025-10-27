import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/storage/domain/entities/movement_item.dart';
import 'package:sales_app/src/features/storage/domain/valueObjects/movement_source.dart';
import 'package:sales_app/src/features/storage/domain/valueObjects/movement_type.dart';

part 'stock_movement.freezed.dart';
part 'stock_movement.g.dart';

@freezed
abstract class StockMovement with _$StockMovement {
  const StockMovement._();

  const factory StockMovement.raw({
    required int id,      // id local
    required String code,
    int? serverId,             // id do servidor
    int? userId,
    String? description,
    int? orderId,              // Link com um pedido
    required DateTime createAt,
    required MovementType type,
    required MovementSource source,
    int? fromStorageId,
    int? toStorageId,
    required List<MovementItem> items,
  }) = _StockMovement;

  factory StockMovement ({
    required int id,
    required String code,
    int? serverId,
    int? userId,
    required String? description,
    int? orderId,
    required DateTime createAt,
    required MovementType type,
    required MovementSource source,
    int? fromStorageId,
    int? toStorageId,
    required List<MovementItem> items
  }) {
    /// TODO: Fazer as validações

    return StockMovement.raw(
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

  factory StockMovement.fromJson(Map<String, dynamic> json) =>
      _$StockMovementFromJson(json);
}
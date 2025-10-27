import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/storage/data/models/movement_item_model.dart';
import 'package:sales_app/src/features/storage/domain/entities/stock_movement.dart';
import 'package:sales_app/src/features/storage/domain/valueObjects/movement_source.dart';
import 'package:sales_app/src/features/storage/domain/valueObjects/movement_type.dart';

@Entity()
class StockMovementModel {
  @Id()
  int id;

  int stockId;
  String code;
  int? serverId;
  int? userId;
  String? description;
  int? orderId;
  DateTime createAt;
  int? fromStorageId;
  int? toStorageId;
  int type;
  int source;

  final items = ToMany<MovementItemModel>();

  StockMovementModel ({
    this.id = 0,
    this.stockId = 0,
    required this.code,
    this.serverId,
    this.userId,
    this.description,
    this.orderId = 0,
    required this.createAt,
    this.fromStorageId,
    this.toStorageId,
    required this.type,
    required this.source
  });
}

extension StockMovementModelMapper on StockMovementModel {
  /// De StockMovementModel → StockMovement
  StockMovement toEntity() {
    final items = this.items.map((m) => m.toEntity()).toList();

    return StockMovement(
      id: stockId,
      code: code,
      serverId: serverId,
      userId: userId,
      description: description,
      orderId: orderId,
      createAt: createAt,
      fromStorageId: fromStorageId,
      toStorageId: toStorageId,
      type: MovementType.values[type],
      source: MovementSource.values[source],
      items: items
    );
  }
}

extension StockMovementMapper on StockMovement {
  /// De StockMovement → StockMovementModel
  StockMovementModel toModel() {
    final model = StockMovementModel(
      stockId: id,
      code: code,
      serverId: serverId,
      userId: userId,
      description: description,
      orderId: orderId,
      createAt: createAt,
      fromStorageId: fromStorageId,
      toStorageId: toStorageId,
      type: type.index,
      source: source.index
    );

    model.items.addAll(items.map((i) => i.toModel()));

    return model;
  }
}
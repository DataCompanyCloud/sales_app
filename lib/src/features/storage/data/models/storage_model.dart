import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/storage/data/models/stock_movement_model.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';

@Entity()
class StorageModel {
  @Id()
  int id;

  int storageId;
  String name;
  String? description;
  bool isActive;
  DateTime updatedAt;

  final movements = ToMany<StockMovementModel>();

  StorageModel ({
    this.id = 0,
    this.storageId = 0,
    required this.name,
    this.description,
    required this.isActive,
    required this.updatedAt
  });
}

extension StorageModelMapper on StorageModel {
  /// De StorageModel → Storage
  Storage toEntity() {
    final movements = this.movements.map((m) => m.toEntity()).toList();

    return Storage(
      storageId: storageId,
      name: name,
      description: description,
      isActive: isActive,
      updatedAt: updatedAt,
      movements: movements
    );
  }
}

extension StorageMapper on Storage {
  /// De Storage → StorageModel
  StorageModel toModel() {
    final model = StorageModel(
      storageId: storageId,
      name: name,
      description: description,
      isActive: isActive,
      updatedAt: updatedAt,
    );

    if (movements.isNotEmpty) {
      model.movements.addAll(movements.map((m) => m.toModel()));
    }

    return model;
  }
}
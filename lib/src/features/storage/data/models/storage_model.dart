import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/stockTransaction/data/models/stock_transaction_model.dart';
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

  final transaction = ToMany<StockTransactionModel>();

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
    final transaction = this.transaction.map((m) => m.toEntity());

    return Storage(
      storageId: storageId,
      name: name,
      description: description,
      isActive: isActive,
      updatedAt: updatedAt,
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

    return model;
  }
}
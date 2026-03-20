import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/company/domain/entities/company.dart';
import 'package:sales_app/src/features/stockTransaction/data/models/stock_transaction_model.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';

@Entity()
class StorageModel {
  @Id()
  int id;

  String uuid;
  String code;
  String name;
  bool isSystem;
  bool isActive;
  int? companyId;
  Company? company;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? description;

  final transaction = ToMany<StockTransactionModel>();

  StorageModel ({
    this.id = 0,
    required this.uuid,
    required this.code,
    required this.name,
    required this.isSystem,
    required this.isActive,
    this.companyId,
    this.company,
    this.createdAt,
    this.updatedAt,
    this.description,
  });
}

extension StorageModelMapper on StorageModel {
  /// De StorageModel → Storage
  Storage toEntity() {

    return Storage.raw(
      id: id,
      uuid: uuid,
      code: code,
      name: name,
      isSystem: isSystem,
      isActive: isActive,
      companyId: companyId,
      company: company,
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: description,
    );
  }
}

extension StorageMapper on Storage {
  /// De Storage → StorageModel
  StorageModel toModel() {
    final model = StorageModel(
      id: id,
      uuid: uuid,
      code: code,
      name: name,
      isSystem: isSystem,
      isActive: isActive,
      companyId: companyId,
      company: company,
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: description,
    );

    return model;
  }
}
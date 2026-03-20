import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/company/domain/entities/company.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';

part 'storage.freezed.dart';
part 'storage.g.dart';

@freezed
abstract class Storage with _$Storage {
  const Storage._();

  const factory Storage.raw({
    required int id,          // ID local
    required String uuid,
    required String code,
    required String name,            // Nome do local (ex: "Depósito Central")
    required bool isSystem,
    required bool isActive,          // Indica se o storage está ativo
    int? companyId,
    Company? company,
    DateTime? createdAt,
    DateTime? updatedAt,     // Última atualização
    String? description,             // Descrição opcional
    @Default([])List<StorageProduct> products,
  }) = _Storage;

  factory Storage ({
    required int id,
    required String uuid,
    required String code,
    required String name,
    required bool isSystem,
    required bool isActive,
    int? companyId,
    Company? company,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    required List<StorageProduct> products,
  }) {
    /// TODO: Fazer as validações

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
      products: products,
    );
  }

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);
}
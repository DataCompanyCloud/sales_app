import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';

part 'storage.freezed.dart';
part 'storage.g.dart';

@freezed
abstract class Storage with _$Storage {
  const Storage._();

  const factory Storage.raw({
    required int storageId,          // ID local
    required String name,            // Nome do local (ex: "Depósito Central")
    String? description,             // Descrição opcional
    required bool isActive,          // Indica se o storage está ativo
    required DateTime updatedAt,     // Última atualização
    @Default([])List<StorageProduct> products,
  }) = _Storage;

  factory Storage ({
    required int storageId,
    required String name,
    String? description,
    required bool isActive,
    required DateTime updatedAt,
    required List<StorageProduct> products,
  }) {
    /// TODO: Fazer as validações

    return Storage.raw(
      storageId: storageId,
      name: name,
      description: description,
      isActive: isActive,
      updatedAt: updatedAt,
      products: products,
    );
  }

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);
}
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';

class StorageProductsFilter {
  final String storageCode;
  final int start;
  final int limit;
  final String? q;

  const StorageProductsFilter({
    required this.storageCode,
    this.start = 0,
    this.limit = 20,
    this.q,
  });

  StorageProductsFilter copyWith ({
    int? storageCode,
    int? start,
    // int? limit,
    String? q,
  }) {
    return StorageProductsFilter(
      storageCode: this.storageCode,
      start: start ?? this.start,
      limit: limit,
      q: q ?? this.q,
    );
  }
}

abstract class StorageProductsRepository {
  /// Busca todos os produtos de um estoque
  Future<List<StorageProduct>> fetchAll(StorageProductsFilter filter);
  /// Busca os produtos de um estoque pelo CODE
  Future<StorageProduct> fetchByCode(String storageCode, String productCode);
  /// Salva vários produtos de um estoque
  Future<void> saveAll(List<StorageProduct> storageProducts);
  /// Salva um produto de um estoque
  Future<StorageProduct> save(StorageProduct storage);
  /// Remove os produtos de um estoque
  Future<void> deleteAll(String storageCode);
  /// Retorna a quantidade total de podutos em um estoque
  Future<int> count();
}
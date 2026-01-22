import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';

class StorageProductsFilter {
  final int start;
  final int limit;
  final String? q;

  const StorageProductsFilter({
    this.start = 0,
    this.limit = 20,
    this.q,
  });

  StorageProductsFilter copyWith ({
    int? storageId,
    int? start,
    // int? limit,
    String? q,
  }) {
    return StorageProductsFilter(
      start: start ?? this.start,
      limit: limit,
      q: q ?? this.q,
    );
  }
}

abstract class StorageProductsRepository {
  /// Busca todos os produtos de um estoque
  Future<List<StorageProduct>> fetchAll(StorageProductsFilter filter);
  /// Busca os produtos de um estoque pelo ID
  Future<StorageProduct> fetchById(int storageId, int productId);
  /// Salva vários produtos de um estoque
  Future<void> saveAll(List<StorageProduct> storageProducts);
  /// Salva um produto de um estoque
  Future<StorageProduct> save(StorageProduct storage);
  /// Retorna a quantidade total de podutos em um estoque
  Future<int> count();
}
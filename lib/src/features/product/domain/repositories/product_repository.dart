import 'package:sales_app/src/features/product/domain/entities/product.dart';

enum ProductDirection { asc, desc }

class ProductFilter {
  final int start;
  final int limit;
  final String? q;
  final String? walletCode;
  final ProductDirection direction;

  const ProductFilter({
    this.start = 0,
    this.limit = 20,
    this.q,
    this.walletCode,
    this.direction = ProductDirection.desc,
  });

  ProductFilter copyWith ({
    int? start,
    // int? limit,
    String? q,
    String? walletCode,
    ProductDirection? direction,
  }) {
    return ProductFilter(
      start: start ?? this.start,
      limit: limit,
      q: q ?? this.q,
      walletCode: walletCode ?? this.walletCode,
      direction: direction ?? this.direction,
    );
  }
}

abstract class ProductRepository {
  /// Busca todos os Produtos
  Future<List<Product>> fetchAll(ProductFilter filter);
  /// Busca um produto pelo ID
  Future<Product> fetchById(int id);
  /// Salva vários produtos
  Future<void> saveAll(List<Product> products);
  /// Salva um produto
  Future<Product> save(Product product);
  /// Remove um produto
  Future<void> delete(Product product);
  /// Remove TODOS os produtos
  Future<void> deleteAll();
  /// Retorna a quantidade total de produtos no banco
  Future<int> count();
}
import 'package:sales_app/src/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  /// Busca todos os Produtos
  Future<List<Product>> fetchAll();
  /// Busca um produto pelo ID
  Future<Product> fetchById(int id);
  /// Insere um novo produto
  Future<Product> insert(Product product);
  /// Atualiza um produto já existente
  Future<void> update(Product product);
  /// Remove um produto
  Future<void> delete(Product product);
  /// Remove TODOS os produtos
  Future<void> deleteAll();
}
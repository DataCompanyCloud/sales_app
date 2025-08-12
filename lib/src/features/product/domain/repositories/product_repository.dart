import 'package:sales_app/src/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  /// Busca todos os Produtos
  Future<List<Product>> fetchAll({String? search});
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
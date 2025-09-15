import 'package:sales_app/src/features/order/domain/entities/order.dart';

abstract class OrderRepository {
  /// Busca todos os Pedidos
  Future<List<Order>> fetchAll({String? search});
  /// Busca um pedido pelo ID
  Future<Order> fetchById(int orderId);
  /// Salva vários pedidos
  Future<void> saveAll(List<Order> orders);
  /// Salva um pedido
  Future<Order> save(Order order);
  /// Remove um pedido
  Future<void> delete(Order order);
  /// Remove TODOS os pedidos
  Future<void> deleteAll();
  /// Retorna a quantidade total de pedidos no banco
  Future<int> count();
}
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/sales_order_status.dart';

enum SortDirection { asc, desc }

enum SalesOrderSortField {
  createdAt,
  updatedAt,
  total,
  customerName,
  itemsCount,
}

class SalesOrderFilter {
  final int start;
  final int limit;
  final String? q;
  final SalesOrderStatus? status;
  final bool onlyPendingSync;
  final SalesOrderSortField orderBy;
  final SortDirection direction;

  const SalesOrderFilter({
    this.start = 0,
    this.limit = 20,
    this.q,
    this.status,
    this.onlyPendingSync = false,
    this.orderBy = SalesOrderSortField.createdAt,
    this.direction = SortDirection.desc,
  });

  SalesOrderFilter copyWith({
    int? start,
    // int? limit,
    String? q,
    SortDirection? direction,
  }) {
    return SalesOrderFilter(
      start: start ?? this.start,
      limit: limit,
      q: q ?? this.q,
      direction: direction ?? this.direction,
    );
  }
}

abstract class SalesOrderRepository {
  /// Busca todos os Pedidos
  Future<List<SalesOrder>> fetchAll(SalesOrderFilter filter);
  /// Busca um pedido pelo ID
  Future<SalesOrder> fetchById(int orderId);
  /// Salva vários pedidos
  Future<void> saveAll(List<SalesOrder> orders);
  /// Salva um pedido
  Future<SalesOrder> save(SalesOrder order);
  /// Remove um pedido
  Future<void> delete(SalesOrder order);
  /// Remove TODOS os pedidos
  Future<void> deleteAll();
  /// Retorna a quantidade total de pedidos no banco
  Future<int> count();
}
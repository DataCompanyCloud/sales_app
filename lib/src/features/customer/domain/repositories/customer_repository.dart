import 'package:sales_app/src/features/customer/domain/entities/customer.dart';

enum CustomerDirection { asc, desc }

class CustomerFilter {
  final int start;
  final int limit;
  final String? q;
  final CustomerDirection direction;

  const CustomerFilter({
    this.start = 0,
    this.limit = 20,
    this.q,
    this.direction = CustomerDirection.desc,
  });

  CustomerFilter copyWith ({
    int? start,
    // int? limit,
    String? q,
    CustomerDirection? direction
  }) {
    return CustomerFilter(
      start: start ?? this.start,
      limit: limit,
      q: q ?? this.q,
      direction: direction ?? this.direction,
    );
  }
}


abstract class CustomerRepository {
  /// Busca todos os Clientes
  Future<List<Customer>> fetchAll(CustomerFilter filter);
  /// Busca um cliente pelo ID
  Future<Customer> fetchById(int customerId);
  /// Salva vários cliente
  Future<void> saveAll(List<Customer> customers);
  /// Salva um cliente
  Future<Customer> save(Customer customer);
  /// Remove um cliente
  Future<void> delete(Customer customer);
  /// Remova TODOS os cliente
  Future<void> deleteAll();
  /// Retorna a quantidade total de clientes no banco
  Future<int> count();
}
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/customer_filter.dart';

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
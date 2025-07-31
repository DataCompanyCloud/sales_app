import 'package:sales_app/src/features/customer/domain/entities/customer.dart';

abstract class CustomerRepository {
  /// Busca todos os Clientes
  Future<List<Customer>> fetchAll();
  /// Busca um cliente pelo ID
  Future<Customer> fetchById(int customerId);
  /// Insere um novo cliente
  Future<Customer> insert(Customer customer);
  /// Atualiza um cliente já existente
  Future<void> update(Customer customer);
  /// Remove um cliente
  Future<void> delete(Customer customer);
  /// Remova TODOS os cliente
  Future<void> deleteAll();
}
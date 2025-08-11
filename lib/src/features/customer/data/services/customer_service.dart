import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/repositories/customer_repository.dart';

class CustomerService {
  final CustomerRepository repository;

  final ApiClient apiClient;

  CustomerService(this.apiClient, this.repository);

  Future<List<Customer>> getAll({int start = 0, int limit = 30, String? search}) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.customers, queryParameters: {
      'search': search,
      'start': start,
      'limit': start,
    });

    final data = json['data'] as List<dynamic>;

    final customers = data
      .map((c) {
        return Customer.fromJson(c);
      }).toList();

    return customers;
  }

  Future<Customer> getById(int customerId) async {
    try {
      final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.customerById(customerId: customerId));
      return Customer.fromJson(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_002_CUSTOMER_SERVER_NOT_FOUND, "Usuário não existe");
      }

      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Falha em obter usuário");
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }

  Future<int> putCustomer(Customer customer) async {
    final json = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.customers,
      data: customer.toJson(),
    );

    if (json['serverId'] == null) {
      throw Exception('Falha ao criar customer: resposta inválida do servidor');
    }

    return json['serverId'] as int;

  }
}



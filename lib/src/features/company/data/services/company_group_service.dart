import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/company/domain/entities/company.dart';
import 'package:sales_app/src/features/company/domain/entities/company_group.dart';
import 'package:sales_app/src/features/company/domain/repositories/company_group_repository.dart';

class CompanyGroupService {
  final ApiClient apiClient;

  CompanyGroupService(this.apiClient);

  Future<List<CompanyGroup>> getAll(CompanyGroupFilter filter) async {
    return [];
    // final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.customers, queryParameters: {
    //   'search': filter.q,
    //   'start': filter.start,
    //   'limit': filter.limit,
    // });
    //
    // final data = json['data'] as List<dynamic>;
    //
    // final customers = data
    //     .map((c) {
    //   return Company.fromJson(c);
    // }).toList();
    //
    // return customers;
  }

  // Future<Company> getById(int companyId) async {
  //   try {
  //     final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.customerById(customerId: customerId));
  //     return Company.fromJson(json);
  //   } on DioException catch (e) {
  //     final status = e.response?.statusCode;
  //
  //     if (status == 404) {
  //       throw AppException(AppExceptionCode.CODE_002_CUSTOMER_SERVER_NOT_FOUND, "Usuário não existe");
  //     }
  //
  //     throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Falha em obter usuário");
  //   } catch (e) {
  //     throw AppException.errorUnexpected(e.toString());
  //   }
  // }

  Future<int> putCompany(Company customer) async {
    final json = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.customers,
      data: customer.toJson(),
    );

    if (json['serverId'] == null) {
      throw AppException(AppExceptionCode.CODE_042_CREATE_CUSTOMER_FAILED, "Falha ao criar cliente: resposta inválida do servidor.");
    }

    return json['serverId'] as int;

  }
}



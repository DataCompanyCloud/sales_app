import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_repository.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/valueObjects/storages_pagination.dart';

class StorageService {
  final StorageRepository repository;
  
  final ApiClient apiClient;
  
  StorageService(this.apiClient, this.repository);
  
  Future<StoragesPagination> getAll(StorageFilter filter) async {
    final json = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.storages, queryParameters: {
      'q': filter.q,
      'start': filter.start,
      'limit': filter.limit,
    });

    final data = json['data'] as List<dynamic>;

    final storages = data
        .map((s) {
      return Storage.fromJson(s);
    }).toList();

    return StoragesPagination(
        total: json['total'] ?? storages.length,
        items: storages
    );
  }

  Future<Storage> getById(int storageId) async {
    try {
      final json = await apiClient.get<Map<String, dynamic>>(
          ApiEndpoints.storageById(storageId: storageId));
      return Storage.fromJson(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Estoque não existe");
      }

      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Falha em obter estoque");
    } catch (s) {
      throw AppException.errorUnexpected(s.toString());
    }
  }

  Future<int> getCount(StorageFilter filter) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.storages,
      queryParameters: {
        'q': filter.q,
      },
    );

    final data = json['total'];

    return data is int ? data : int.tryParse(data.toString()) ?? 0;
  }
}
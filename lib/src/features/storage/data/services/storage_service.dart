import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_repository.dart';

class StorageService {
  final StorageRepository repository;
  
  final ApiClient apiClient;
  
  StorageService(this.apiClient, this.repository);
  
  Future<List<Storage>> getAll({int start = 0, int limit = 10, String? search}) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.storages, queryParameters: {
      'search': search,
      'start': start,
      'limit': start
    });

    final data = json['data'] as List<dynamic>;

    final storages = data
        .map((s) {
      return Storage.fromJson(s);
    }).toList();

    return storages;
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
}
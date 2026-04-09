import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_products_repository.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_repository.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/valueObjects/storage_products_pagination.dart';

class StorageProductsService {
  final StorageProductsRepository repository;

  final ApiClient apiClient;

  StorageProductsService(this.apiClient, this.repository);

  Future<StorageProductsPagination> getAll(StorageProductsFilter filter, String code) async {
    final json = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.storageProducts(code: code), queryParameters: {
        'q': filter.q,
        'start': filter.start,
        'limit': filter.limit,
      });

    final data = json['data'] as List<dynamic>;

    final storageProducts = data
        .map((s) {
      return StorageProduct.fromJson(s);
    }).toList();

    return StorageProductsPagination(
        total: json['total'] ?? storageProducts.length,
        items: storageProducts
    );
  }

  Future<List<StorageProduct>> fetchByStorage(String uuid) async {
    try {
      final json = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.storageProductByUuId(uuid: uuid)
      );

      final items = json['items'] as List;

      return items.map((e) => StorageProduct.fromJson(e)).toList();
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_046_STORAGE_DO_NOT_EXIST, "Estoque não existe.");
      }

      throw AppException(AppExceptionCode.CODE_047_STORAGE_NOT_FOUND, "Falha em obter estoque.");
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
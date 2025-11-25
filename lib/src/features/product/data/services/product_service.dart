import 'dart:math';
import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';

class ProductService {
  final ApiClient apiClient;

  ProductService(this.apiClient);

  Future<List<Product>> getAll(ProductFilter filter) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.products, queryParameters: {
      'q': filter.q,
      'start': filter.start,
      'limit': filter.limit,
    });

    final data = json['data'] as List<dynamic>;

    final products = data
        .map((p) {
      return Product.fromJson(p);
    }).toList();

    return products;
  }

  Future<Product> getById(int productId) async {
    try {
      final json = await apiClient.get<Map<String, dynamic>>(
          ApiEndpoints.productById(productId: productId));
      return Product.fromJson(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_005_PRODUCT_SERVER_NOT_FOUND, "Produto não existe");
      }

      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Falha em obter produto");
    } catch (p) {
      throw AppException.errorUnexpected(e.toString());
    }
  }
}
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';

class ProductService {
  final ProductRepository repository;

  final ApiClient apiClient;

  ProductService(this.apiClient, this.repository);

  Future<List<Product>> getAll({int start = 0, int limit = 30, String? search}) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.products, queryParameters: {
      'search': search,
      'start': start,
      'limit': start,
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
        throw AppException(AppExceptionCode.CODE_002_CUSTOMER_SERVER_NOT_FOUND, "Produto não existe");
      }

      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Falha em obter usuário");
    } catch (p) {
      throw AppException.errorUnexpected(e.toString());
    }
  }
}
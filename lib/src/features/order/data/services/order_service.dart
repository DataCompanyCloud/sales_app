import 'dart:math';
import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/domain/repositories/order_repository.dart';

class OrderService {
  final OrderRepository repository;

  final ApiClient apiClient;

  OrderService(this.apiClient, this.repository);

  Future<List<Order>> getAll({
    int start = 0,
    int limit = 30,
    String? search,
    bool withProducts = false
  }) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.orders, queryParameters: {
      'search': search,
      'start': start,
      'limit': limit,
      'withProducts': bool
    });

    final data = json['data'] as List<dynamic>;

    final orders = data.map((o) {
      return Order.fromJson(o);
    }).toList();

    return orders;
  }

  Future<Order> getById(int orderId) async {
    try {
      final json = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.orderById(orderId: orderId));
      return Order.fromJson(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Pedido não existe");
      }

      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Falha em obter pedido");
    } catch (o) {
      throw AppException.errorUnexpected(e.toString());
    }
  }
}
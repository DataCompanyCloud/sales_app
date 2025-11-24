import 'dart:math';
import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/sales_order_repository.dart';

class SalesOrderService {
  final SalesOrderRepository repository;

  final ApiClient apiClient;

  SalesOrderService(this.apiClient, this.repository);

  Future<List<SalesOrder>> getAll({
    required SalesOrderFilter filter,
    bool withProducts = false
  }) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.orders, queryParameters: {
      'q': filter.q,
      'start': filter.start,
      'limit': filter.limit,
      // 'withProducts': bool
    });

    final data = json['data'] as List<dynamic>;

    final orders = data.map((o) {
      return SalesOrder.fromJson(o);
    }).toList();

    return orders;
  }

  Future<SalesOrder> getById(int orderId) async {
    try {
      final json = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.orderById(orderId: orderId));
      return SalesOrder.fromJson(json);
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



  Future<void> save(SalesOrder salesOrder) async {
    try {
      final json = await apiClient.post(ApiEndpoints.orders, data: salesOrder.toJson());
      print(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Falha em obter pedido");
    } catch (o) {
      throw AppException.errorUnexpected(e.toString());
    }
  }
}
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction.dart';
import 'package:sales_app/src/features/stockTransaction/domain/repositories/transaction_repository.dart';

class TransactionService {
  final TransactionRepository repository;

  final ApiClient apiClient;

  TransactionService(this.apiClient, this.repository);

  Future<List<StockTransaction>> getAll({
    int start = 0,
    int limit = 30,
  }) async {
    final json = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.stockTransaction, queryParameters: {
      'start': start,
      'limit': limit,
    });

    final data = json['data'] as List<dynamic>;

    final stockTransactions = data.map((s) {
      return StockTransaction.fromJson(s);
    }).toList();

    return stockTransactions;
  }

  Future<StockTransaction> getById(int id) async {
    try {
      final json = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.stockTransactionById(id: id));
      return StockTransaction.fromJson(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_048_TRANSACTION_DO_NOT_EXIST, "Transação não existe.");
      }

      throw AppException(AppExceptionCode.CODE_049_TRANSACTION_NOT_FOUND, "Falha em obter transação.");
    } catch (s) {
      throw AppException.errorUnexpected(e.toString());
    }
  }
}
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/features/stockTransaction/domain/repositories/transaction_repository.dart';

class TransactionService {
  final TransactionRepository repository;

  final ApiClient apiClient;

  TransactionService(this.repository, this.apiClient);


}
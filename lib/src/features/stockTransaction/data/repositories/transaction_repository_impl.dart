import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/stockTransaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  final Store store;

  TransactionRepositoryImpl(this.store);


}
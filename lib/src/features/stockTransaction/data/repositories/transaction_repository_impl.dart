import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/stockTransaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  final Store store;

  TransactionRepositoryImpl(this.store);

  // @override
  // Future<List<StockTransaction>> fetchAll() async {
  //   // TODO: implement fetchAll
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<StockTransaction> fetchById(int id) async {
  //   // TODO: implement fetchById
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<void> saveAll(List<StockTransaction> stockTransactions) async {
  //   // TODO: implement saveAll
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<StockTransaction> save(StockTransaction stockTransactions) async {
  //   // TODO: implement save
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<void> delete(StockTransaction stockTransaction) async {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<void> deleteAll() async {
  //   // TODO: implement deleteAll
  //   throw UnimplementedError();
  // }

}
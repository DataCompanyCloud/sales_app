import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/stockTransaction/data/models/stock_transaction_model.dart';
import 'package:sales_app/src/features/storage/data/models/storage_model.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_repository.dart';

class StorageRepositoryImpl extends StorageRepository {
  final Store store;

  Box<StorageModel> get storageBox => store.box<StorageModel>();
  Box<StockTransactionModel> get stockTransactionBox => store.box<StockTransactionModel>();

  StorageRepositoryImpl(this.store);

  @override
  Future<List<Storage>> fetchAll(StorageFilter filter) async {
    final box = store.box<StorageModel>();
    Condition<StorageModel>? cond;

    final raw = filter.q?.trim();
    if (raw != null && raw.isNotEmpty) {
      cond = StorageModel_.name.contains(raw, caseSensitive: false);
    }

    final qb = (cond == null) ? box.query() : box.query(cond);

    final q = qb.build()
      ..offset = filter.start
      ..limit = filter.limit
    ;

    try {
      final models = await q.findAsync(

      );
      return models.map((m) => m.toEntity()).toList();
    } finally {
      q.close();
    }
  }

  @override
  Future<Storage> fetchById(int storageId) async {
    try {
      final storageBox = store.box<StorageModel>();

      final model = await storageBox.getAsync(storageId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Estoque não encontrado");
      }

      return model.toEntity();
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }

  @override
  Future<void> saveAll(List<Storage> storages) async {
    final storageBox = store.box<StorageModel>();
    final stockTransactionBox = store.box<StockTransactionModel>();

    store.runInTransaction(TxMode.write, () {
      for (final storage in storages) {
        final existing = storageBox.get(storage.storageId);

        final newModel = storage.maybeMap(
          raw: (r) => r.toModel(),
          orElse: () => throw AppException(
            AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
            "Dados do Estoque inválidos para atualização",
          ),
        );

        if (existing != null) {
          for (final movement in existing.transaction) {
            stockTransactionBox.remove(movement.id);
          }
        } else {
          newModel.id = 0;
        }

        storageBox.put(newModel);
      }
    });
  }

  @override
  Future<Storage> save(Storage storage) async {
    final storageBox = store.box<StorageModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existing = storageBox.get(storage.storageId);

      final newModel = storage.maybeMap(
        raw: (r) => r.toModel(),
        orElse: () => throw AppException(
          AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
          "Dados do Estoque inválidos para atualização",
        ),
      );

      if (existing != null) {
        // for (final movement in existing.movements.target.id) {
        //   stockTransactionBox.remove(movement.id);
        // }

        newModel.id = existing.id;
      } else {
        newModel.id = 0;
      }

      storageBox.put(newModel);
    });

    final saved = await storageBox.getAsync(id);
    if (saved == null) {
      throw AppException(
        AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
        "Estoque não encontrado após sua inserção",
      );
    }
    return saved.toEntity();
  }

  // @override
  // Future<Storage> update(Storage storage) async {
  //   final storageBox = store.box<StorageModel>();
  //   final stockMovementsBox = store.box<StockMovementModel>();
  //
  //   store.runInTransaction(TxMode.write, () {
  //     final existing = storageBox.get(storage.storageId);
  //
  //     if (existing == null) {
  //       throw AppException(
  //         AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Estoque não encontrado para atualização",
  //       );
  //     }
  //
  //   });
  //
  // }

  @override
  Future<void> delete(Storage storage) async {
    final storageBox = store.box<StorageModel>();
    final stockTransactionBox = store.box<StockTransactionModel>();

    store.runInTransaction(TxMode.write, () async {
      final model = await storageBox.getAsync(storage.storageId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Estoque não encontrado");
      }

      for (final movement in model.transaction) {
        stockTransactionBox.remove(movement.id);
      }

      await storageBox.removeAsync(model.id);
    });
  }

  @override
  Future<void> deleteAll() async {
    final storageBox = store.box<StorageModel>();
    final stockTransactionBox = store.box<StockTransactionModel>();

    store.runInTransaction(TxMode.write, () {
      final allStorages = storageBox.getAll();

      for (final model in allStorages) {
        for (final movement in model.transaction) {
          stockTransactionBox.remove(movement.id);
        }
      }

      storageBox.removeAll();
    });
  }

  @override
  Future<int> count() {
    final storageBox = store.box<StorageModel>();
    return Future.value(storageBox.count());
  }
}

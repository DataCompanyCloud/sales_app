import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/storage/data/models/stock_movement_model.dart';
import 'package:sales_app/src/features/storage/data/models/storage_model.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_repository.dart';

import '../../../../../objectbox.g.dart';

class StorageRepositoryImpl extends StorageRepository {
  final Store store;

  StorageRepositoryImpl(this.store);

  @override
  Future<List<Storage>> fetchAll({String? search}) async {
    final box = store.box<StorageModel>();

    final raw = (search ?? '').trim();
    if (raw.isEmpty) {
      final all = await box.getAllAsync();
      return all.map((m) => m.toEntity()).toList();
    }

    final term = raw.toLowerCase();
    final digits = raw.replaceAll(RegExp(r'\D+'), '');

    final storageNameCond = StorageModel_.name.contains(term, caseSensitive: false);
    final storageNameQuery = box.query(storageNameCond).build();
    final byStorageName = await storageNameQuery.findAsync();
    storageNameQuery.close();

    final seen = <int>{};
    final merged = <StorageModel>[];
    for (final m in [...byStorageName]) {
      if (seen.add(m.id)) merged.add(m);
    }

    return merged.map((m) => m.toEntity()).toList();
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
    final stockMovementsBox = store.box<StockMovementModel>();

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
          for (final movement in existing.movements) {
            stockMovementsBox.remove(movement.id);
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
    final stockMovementsBox = store.box<StockMovementModel>();

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
  //   final movementItemBox = store.box<MovementItemModel>();
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
  //     // Atualiza campos simples
  //     existing.name = storage.name;
  //     existing.location = storage.location;
  //     existing.updatedAt = DateTime.now();
  //
  //     // Atualiza movimentos sem remover os existentes
  //     for (final movement in storage.stockMovements) {
  //       final existingMovement = existing.stockMovements
  //         .firstWhere((m) => m.id == movement.id, orElse: () => StockMovementModel());
  //
  //       existingMovement.type = movement.type;
  //       existingMovement.date = movement.date;
  //
  //       // Atualiza itens do movimento
  //       for (final item in movement.items) {
  //         final existingItem = existingMovement.items
  //           .firstWhere((i) => i.id == item.id, orElse: () => MovementItemModel());
  //         existingItem.productId = item.productId;
  //         existingItem.quantity = item.quantity;
  //         existingItem.price = item.price;
  //         movementItemBox.put(existingItem);
  //       }
  //
  //       stockMovementsBox.put(existingMovement);
  //       if (!existing.stockMovements.contains(existingMovement)) {
  //         existing.stockMovements.add(existingMovement);
  //       }
  //     }
  //
  //     storageBox.put(existing);
  //   });
  //
  //   // Retorna o objeto atualizado
  //   final updated = storageBox.get(storage.storageId);
  //   return updated!.toEntity();
  // }

  @override
  Future<void> delete(Storage storage) async {
    final storageBox = store.box<StorageModel>();
    final stockMovementBox = store.box<StockMovementModel>();

    store.runInTransaction(TxMode.write, () async {
      final model = await storageBox.getAsync(storage.storageId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Estoque não encontrado");
      }

      for (final movement in model.movements) {
        stockMovementBox.remove(movement.id);
      }

      await storageBox.removeAsync(model.id);
    });
  }

  @override
  Future<void> deleteAll() async {
    final storageBox = store.box<StorageModel>();
    final stockMovementBox = store.box<StockMovementModel>();

    store.runInTransaction(TxMode.write, () {
      final allStorages = storageBox.getAll();

      for (final model in allStorages) {
        for (final movement in model.movements) {
          stockMovementBox.remove(movement.id);
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
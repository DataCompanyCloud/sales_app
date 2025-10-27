import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
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
    // final storageBox = store.box<StorageModel>();
    // final stockMovementsBox = store.box<StockMovementModel>();
    // final movementItemBox = store.box<MovementItemModel>();
    //
    // store.runInTransaction(TxMode.write, () {
    //   for (final storage in storages) {
    //     final existing = storageBox.get(storage.storageId);
    //
    //     final newModel = storage.maybeMap(
    //       orElse: () =>
    //       throw AppException(
    //         AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
    //         "Dados do Estoque inválidos para atualização",
    //       ),
    //     );
    //   }
    // });
  }

  @override
  Future<Storage> save(Storage storage) async {
    final storageBox = store.box<StorageModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existing = storageBox.get(storage.storageId);

      final newModel = storage.maybeMap(
        raw: (r) => r.toModel(),
        orElse: () =>
        throw AppException(
          AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
          "Dados do Estoque inválidos para atualização",
        ),
      );

      if (existing != null) {
        newModel.id = existing.id;
      } else {
        newModel.id = 0;
      }

      return storageBox.put(newModel);
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

  @override
  Future<void> delete(Storage storage) async {

  }

  @override
  Future<void> deleteAll() async {

  }

  @override
  Future<int> count() {
    final storageBox = store.box<StorageModel>();
    return Future.value(storageBox.count());
  }

  @override
  Future<Storage> update(Storage storage) async {
    final storageBox = store.box<StorageModel>();
    final stockMovementsBox = store.box<StockMovementModel>();
    final movementItemBox = store.box<MovementItemModel>();

    late StorageModel updatedModel;

    await store.runInTransactionAsync(TxMode.write, (Store txStore) async {
      final existing = storageBox.get(storage.storageId);

      if (existing == null) {
        throw AppException(
          AppExceptionCode.CODE_404_NOT_FOUND,
          "Estoque não encontrado para atualização",
        );
      }

      // converte o domínio para modelo
      final newModel = StorageModel.fromEntity(storage);

      // faz merge dos campos — mantendo dados locais que não devem ser sobrescritos
      existing.name = newModel.name;
      existing.location = newModel.location;
      existing.updatedAt = DateTime.now();
      existing.stockMovements = newModel.stockMovements;

      // grava a atualização no banco
      storageBox.put(existing);

      // sincroniza movimentos e itens
      for (final movement in storage.stockMovements) {
        final movementModel = StockMovementModel.fromEntity(movement);
        stockMovementsBox.put(movementModel);

        for (final item in movement.items) {
          movementItemBox.put(MovementItemModel.fromEntity(item));
        }
      }

      updatedModel = existing;
      return; // ✅ necessário para não retornar null
    });

    // retorna o domínio atualizado
    return updatedModel.toEntity();
  }


}
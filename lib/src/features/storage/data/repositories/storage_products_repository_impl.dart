import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/storage/data/models/storage_products_model.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_products_repository.dart';

class StorageProductsRepositoryImpl extends StorageProductsRepository {
  final Store store;

  Box<StorageProductModel> get storageProductBox => store.box<StorageProductModel>();

  StorageProductsRepositoryImpl(this.store);

  @override
  Future<List<StorageProduct>> fetchAll(StorageProductsFilter filter) async {
    final box = store.box<StorageProductModel>();
    Condition<StorageProductModel> cond = StorageProductModel_.storageId.equals(filter.storageId);

    final raw = filter.q?.trim();
    if (raw != null && raw.isNotEmpty) {
      cond = StorageProductModel_.productName.contains(raw, caseSensitive: false);
    }

    final q = box.query(cond).build()
      ..offset = filter.start
      ..limit = filter.limit;

    try {
      final models = await q.findAsync();
      return models.map((m) => m.toEntity()).toList();
    } finally {
      q.close();
    }
  }

  @override
  Future<StorageProduct> fetchById(int storageId, int productId) async {
    try {
      final storageProductBox = store.box<StorageProductModel>();

      final model = await storageProductBox.getAsync(storageId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Produtos do estoque não encontrado");
      }

      return model.toEntity();
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }

  @override
  Future<void> saveAll(List<StorageProduct> storageProducts) async {
    final storageProductBox = store.box<StorageProductModel>();

    store.runInTransaction(TxMode.write, () {
      for (final storageProduct in storageProducts) {
        final existingQ = storageProductBox.query(
          StorageProductModel_.storageId.equals(storageProduct.storageId)
              .and(StorageProductModel_.productId.equals(storageProduct.productId)),
        ).build();
        final existing = existingQ.findFirst();
        existingQ.close();

        final newModel = storageProduct.toModel();

        newModel.id = existing?.id ?? 0;

        storageProductBox.put(newModel);
      }
    });
  }

  @override
  Future<StorageProduct> save(StorageProduct storage) async {
    final storageProductBox = store.box<StorageProductModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existing = storageProductBox.get(storage.productId);

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

      storageProductBox.put(newModel);
    });

    final saved = await storageProductBox.getAsync(id);
    if (saved == null) {
      throw AppException(
        AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
        "Estoque não encontrado após sua inserção",
      );
    }
    return saved.toEntity();
  }

  @override
  Future<void> deleteAll(int storageId) async {
    final storageProductBox = store.box<StorageProductModel>();

    store.runInTransaction(TxMode.write, () {
      final allStorageProducts = storageProductBox.getAll();
      for (final model in allStorageProducts) {
        model.deleteRecursively(storageProductBox: storageProductBox);
      }
    });
  }

  @override
  Future<int> count() {
    final storageProductBox = store.box<StorageProductModel>();
    return Future.value(storageProductBox.count());
  }
}

import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/product/data/models/barcode_model.dart';
import 'package:sales_app/src/features/product/data/models/category_model.dart';
import 'package:sales_app/src/features/product/data/models/image_model.dart';
import 'package:sales_app/src/features/product/data/models/packing_model.dart';
import 'package:sales_app/src/features/product/data/models/product_model.dart';
import 'package:sales_app/src/features/product/data/models/unit_model.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final Store store;

  ProductRepositoryImpl(this.store);

  @override
  Future<List<Product>> fetchAll() async {
    final box = store.box<ProductModel>();
    final models = await box.getAllAsync();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Product> fetchById(int id) async {
    final productBox = store.box<ProductModel>();

    final model = await productBox.getAsync(id);

    if (model == null) {
      throw AppException(AppExceptionCode.CODE_004_PRODUCT_LOCAL_NOT_FOUND, "Produto não encontrado");
    }

    return model.toEntity();
  }

  @override
  Future<Product> insert(Product product) async {
    final productBox = store.box<ProductModel>();
    final barcodeBox = store.box<BarcodeModel>();
    final unitBox = store.box<UnitModel>();
    final imageBox = store.box<ImageModel>();
    final categoryBox = store.box<CategoryModel>();
    final packingBox = store.box<PackingModel>();

    final insertId = store.runInTransaction(TxMode.write, () {
      final oldModel = productBox.get(product.productId);

      // Cria novo modelo com os dados atualizados
      final newModel = product.maybeMap(
        raw: (r) => r.toModel(),
        orElse: () => throw AppException(AppExceptionCode.CODE_006_PRODUCT_DATA_INVALID, "Dados do Produto inválidos para atualização"),
      );

      if (oldModel != null) {
        // Limpa relacionamentos antigos
        if (oldModel.barcode.target != null) barcodeBox.remove(oldModel.barcode.targetId);
        if (oldModel.unit.target != null) unitBox.remove(oldModel.unit.targetId);

        for (final image in oldModel.image) {
          imageBox.remove(image.id);
        }
        for (final category in oldModel.category) {
          categoryBox.remove(category.id);
        }
        for (final packing in oldModel.packing) {
          packingBox.remove(packing.id);
        }

        newModel.id = oldModel.id;
      }

      return productBox.put(newModel);
    });

    final model = await productBox.getAsync(insertId);

    if (model == null) {
      throw AppException(AppExceptionCode.CODE_004_PRODUCT_LOCAL_NOT_FOUND, "Cliente não encontrado após a inserção");
    }

    return model.toEntity();
  }

  @override
  Future<void> update(Product product) async {
    await insert(product);
  }

  @override
  Future<void> delete(Product product) async {
    final productBox = store.box<ProductModel>();
    final barcodeBox = store.box<BarcodeModel>();
    final unitBox = store.box<UnitModel>();
    final imageBox = store.box<ImageModel>();
    final categoryBox = store.box<CategoryModel>();
    final packingBox = store.box<PackingModel>();

    store.runInTransaction(TxMode.write, () async {
      final model = await productBox.getAsync(product.productId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_004_PRODUCT_LOCAL_NOT_FOUND, "Produto não encontrado");
      }

      final barcode = model.barcode.target;
      if (barcode != null) await barcodeBox.removeAsync(barcode.id);

      final unit = model.unit.target;
      if (unit != null) await unitBox.removeAsync(unit.id);

      for (final category in model.category) {
        await categoryBox.removeAsync(category.id);
      }
      for (final image in model.image) {
        await imageBox.removeAsync(image.id);
      }
      for (final packing in model.packing) {
        await packingBox.removeAsync(packing.id);
      }

      await productBox.removeAsync(model.id);
    });
  }

  @override
  Future<void> deleteAll() async {
    final productBox = store.box<ProductModel>();
    final barcodeBox = store.box<BarcodeModel>();
    final unitBox = store.box<UnitModel>();
    final imageBox = store.box<ImageModel>();
    final categoryBox = store.box<CategoryModel>();
    final packingBox = store.box<PackingModel>();

    store.runInTransaction(TxMode.write, () {
      final allProducts = productBox.getAll();
      for (final model in allProducts) {
        final barcode = model.barcode.target;
        if (barcode != null) barcodeBox.remove(barcode.id);

        for (final category in model.category) {
          categoryBox.remove(category.id);
        }
        for (final image in model.image) {
          imageBox.remove(image.id);
        }
        for (final packing in model.packing) {
          packingBox.remove(packing.id);
        }

        final unit = model.unit.target;
        if (unit != null) {
          unitBox.remove(unit.id);
        }
      }
      productBox.removeAll();
    });
  }
}
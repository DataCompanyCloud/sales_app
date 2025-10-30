import 'package:objectbox/objectbox.dart';
import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/product/data/models/barcode_model.dart';
import 'package:sales_app/src/features/product/data/models/category_model.dart';
import 'package:sales_app/src/features/product/data/models/image_model.dart';
import 'package:sales_app/src/features/product/data/models/packing_model.dart';
import 'package:sales_app/src/features/product/data/models/product_model.dart';
import 'package:sales_app/src/features/product/data/models/attribute_model.dart';
import 'package:sales_app/src/features/product/data/models/unit_model.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final Store store;

  ProductRepositoryImpl(this.store);

  @override
  Future<List<Product>> fetchAll({String? search}) async {
    final box = store.box<ProductModel>();

    // final models = await box.getAllAsync();
    // return models.map((m) => m.toEntity()).toList();

    // Se não houver termo, retorna tudo (ou adapte para paginção/sort)
    final raw = (search ?? '').trim();
    if (raw.isEmpty) {
      final all = await box.getAllAsync();
      return all.map((m) => m.toEntity()).toList();
    }

    final term = raw.toLowerCase();
    final digits = raw.replaceAll(RegExp(r'\D+'), '');

    // 1) Busca pro NOME ('name' do produto)
    /// TODO: Adicionar lógica para buscar por 'name' / nome do produto
    final nameCond = ProductModel_.name.contains(term, caseSensitive: false);
    final nameQuery = box.query(nameCond).build();
    final byName = await nameQuery.findAsync();
    nameQuery.close();

    // 2) Mescla resultados removendo duplicados por id
    final seen = <int>{};
    final merged = <ProductModel>[];
    for (final m in [...byName]) {
      if (seen.add(m.id)) merged.add(m);
    }

    return merged.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Product> fetchById(int productId) async {
    try {
      final productBox = store.box<ProductModel>();

      final model = await productBox.getAsync(productId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_004_PRODUCT_LOCAL_NOT_FOUND, "Produto não encontrado");
      }

      return model.toEntity();
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }

  @override
  Future<void> saveAll(List<Product> products) async {
    final productBox = store.box<ProductModel>();
    final barcodeBox = store.box<BarcodeModel>();
    final unitBox = store.box<UnitModel>();
    final imageBox = store.box<ImageModel>();
    final categoryBox = store.box<CategoryModel>();
    final packingBox = store.box<PackingModel>();
    final attributesBox = store.box<AttributeModel>();

    store.runInTransaction(TxMode.write, () {
      for (final product in products) {
        final existing = productBox.get(product.productId);

        final newModel = product.maybeMap(
          raw: (r) => r.toModel(),
          orElse: () =>
          throw AppException(
            AppExceptionCode.CODE_006_PRODUCT_DATA_INVALID,
            "Dados do Produto inválidos para atualização",
          ),
        );

        if (existing != null) {
          if (existing.barcode.target != null) barcodeBox.remove(existing.barcode.targetId);
          if (existing.unit.target != null) unitBox.remove(existing.unit.targetId);

          for (final packing in existing.packing) {
            packingBox.remove(packing.id);
          }
          for (final category in existing.category) {
            categoryBox.remove(category.id);
          }
          for (final image in existing.image) {
            imageBox.remove(image.id);
          }
          for(final attribute in existing.attributes) {
            attributesBox.remove(attribute.id);
          }

          newModel.id = existing.id;
        } else {
          newModel.id = 0;
        }

        productBox.put(newModel);
      }
    });
  }

  @override
  Future<Product> save(Product product) async {
    final productBox = store.box<ProductModel>();
    final barcodeBox = store.box<BarcodeModel>();
    final unitBox = store.box<UnitModel>();
    final imageBox = store.box<ImageModel>();
    final categoryBox = store.box<CategoryModel>();
    final packingBox = store.box<PackingModel>();
    final attributesBox = store.box<AttributeModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existing = productBox.get(product.productId);

      // Cria o modelo novo a partir da entity
      final newModel = product.maybeMap(
        raw: (r) => r.toModel(),
        orElse: () =>
        throw AppException(
          AppExceptionCode.CODE_006_PRODUCT_DATA_INVALID,
          "Dados do Produto inválidos para atualização",
        ),
      );

      if (existing != null) {
        newModel.id = existing.id;

        // Limpa relacionamentos antigos com checagem de ID > 0
        final barcodeId = existing.barcode.targetId;
        if (barcodeId != 0) barcodeBox.remove(barcodeId);

        final unitId = existing.unit.targetId;
        if (unitId != 0) unitBox.remove(unitId);

        for (final pk in existing.packing) {
          if (pk.id != 0) packingBox.remove(pk.id);
        }

        for (final ct in existing.category) {
          if (ct.id != 0) categoryBox.remove(ct.id);
        }

        for (final img in existing.image) {
          if (img.id != 0) imageBox.remove(img.id);
        }

        for(final attributes in existing.attributes) {
          attributesBox.remove(attributes.id);
        }

      } else {
        newModel.id = 0;
      }

      // Importante: put() cuidará de persistir ToOne/ToMany que você setou em newModel
      return productBox.put(newModel);
    });

    final saved = await productBox.getAsync(id);
    if (saved == null) {
      throw AppException(
        AppExceptionCode.CODE_004_PRODUCT_LOCAL_NOT_FOUND,
        "Produto não encontrado após sua inserção",
      );
    }
    return saved.toEntity();
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

  @override
  Future<int> count() {
    final productBox = store.box<ProductModel>();
    return Future.value(productBox.count());
  }

}
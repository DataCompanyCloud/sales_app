import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/product/data/models/attribute_value_model.dart';
import 'package:sales_app/src/features/product/data/models/barcode_model.dart';
import 'package:sales_app/src/features/product/data/models/category_model.dart';
import 'package:sales_app/src/features/images/data/models/image_model.dart';
import 'package:sales_app/src/features/product/data/models/packing_model.dart';
import 'package:sales_app/src/features/product/data/models/product_fiscal_model.dart';
import 'package:sales_app/src/features/product/data/models/product_model.dart';
import 'package:sales_app/src/features/product/data/models/attribute_model.dart';
import 'package:sales_app/src/features/product/data/models/product_wallet_model.dart';
import 'package:sales_app/src/features/product/data/models/unit_model.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final Store store;

  Box<ProductModel> get productBox => store.box<ProductModel>();
  Box<MoneyModel> get moneyBox => store.box<MoneyModel>();
  Box<BarcodeModel> get barcodeBox => store.box<BarcodeModel>();
  Box<UnitModel> get unitBox => store.box<UnitModel>();
  Box<ImageModel> get imageBox => store.box<ImageModel>();
  Box<CategoryModel> get categoryBox => store.box<CategoryModel>();
  Box<PackingModel> get packingBox => store.box<PackingModel>();
  Box<AttributeModel> get attributeBox => store.box<AttributeModel>();
  Box<AttributeValueModel> get attributeValueBox => store.box<AttributeValueModel>();
  Box<ProductFiscalModel> get productFiscalBox => store.box<ProductFiscalModel>();
  Box<ProductWalletModel> get productWalletBox => store.box<ProductWalletModel>();

  ProductRepositoryImpl(this.store);

  @override
  Future<List<Product>> fetchAll(ProductFilter filter) async {
    final box = store.box<ProductModel>();
    Condition<ProductModel>? cond;

    // Condições
    final raw = filter.q?.trim();
    if (raw != null && raw.isNotEmpty) {
      cond = ProductModel_.name.contains(raw, caseSensitive: false) | ProductModel_.code.contains(raw, caseSensitive: false);
    }

    // Montagem de queries

    final qb = (cond == null) ? box.query() : box.query(cond);



    if (filter.walletCode != null) {
      qb.linkMany(
        ProductModel_.wallets, // relação ToMany<ProductWalletModel>
        ProductWalletModel_.walletCode
            .equals(filter.walletCode!, caseSensitive: false),
      );
    }

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
    store.runInTransaction(TxMode.write, () {
      for (final product in products) {
        final existing = productBox.get(product.productId);
        final newModel = product.toModel();

        newModel.id = existing?.id ?? 0;
        if (existing != null) {
          existing.deleteRecursively(
            productBox: productBox,
            moneyBox: moneyBox,
            barcodeBox: barcodeBox,
            categoryBox: categoryBox,
            imageBox: imageBox,
            packingBox: packingBox,
            unitBox: unitBox,
            attributeBox: attributeBox,
            attributeValueBox: attributeValueBox,
            productFiscalBox: productFiscalBox,
            productWalletBox: productWalletBox
          );
        }

        productBox.put(newModel);
      }
    });
  }

  @override
  Future<Product> save(Product product) async {
    final id = store.runInTransaction(TxMode.write, () {
      final existing = productBox.get(product.productId);

      // Cria o modelo novo a partir da entity
      final newModel = product.toModel();

      newModel.id = existing?.id ?? 0;
      if (existing != null) {
        existing.deleteRecursively(
          productBox: productBox,
          moneyBox: moneyBox,
          barcodeBox: barcodeBox,
          categoryBox: categoryBox,
          imageBox: imageBox,
          packingBox: packingBox,
          unitBox: unitBox,
          attributeBox: attributeBox,
          attributeValueBox: attributeValueBox,
          productFiscalBox: productFiscalBox,
          productWalletBox: productWalletBox
        );
      }

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
    store.runInTransaction(TxMode.write, () async {
      final model = await productBox.getAsync(product.productId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_004_PRODUCT_LOCAL_NOT_FOUND, "Produto não encontrado");
      }

      model.deleteRecursively(
        productBox: productBox,
        moneyBox: moneyBox,
        barcodeBox: barcodeBox,
        categoryBox: categoryBox,
        imageBox: imageBox,
        packingBox: packingBox,
        unitBox: unitBox,
        attributeBox: attributeBox,
        attributeValueBox: attributeValueBox,
        productFiscalBox: productFiscalBox,
        productWalletBox: productWalletBox
      );
    });
  }

  @override
  Future<void> deleteAll() async {
    store.runInTransaction(TxMode.write, () {
      final allProducts = productBox.getAll();
      for (final model in allProducts) {
        model.deleteRecursively(
          productBox: productBox,
          moneyBox: moneyBox,
          barcodeBox: barcodeBox,
          categoryBox: categoryBox,
          imageBox: imageBox,
          packingBox: packingBox,
          unitBox: unitBox,
          attributeBox: attributeBox,
          attributeValueBox: attributeValueBox,
          productFiscalBox: productFiscalBox,
          productWalletBox: productWalletBox
        );
      }
    });
  }

  @override
  Future<int> count() {
    final productBox = store.box<ProductModel>();
    return Future.value(productBox.count());
  }
}
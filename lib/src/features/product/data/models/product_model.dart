import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';
import 'package:sales_app/src/features/product/data/models/attribute_value_model.dart';
import 'package:sales_app/src/features/product/data/models/barcode_model.dart';
import 'package:sales_app/src/features/product/data/models/category_model.dart';
import 'package:sales_app/src/features/images/data/models/image_model.dart';
import 'package:sales_app/src/features/product/data/models/packing_model.dart';
import 'package:sales_app/src/features/product/data/models/attribute_model.dart';
import 'package:sales_app/src/features/product/data/models/product_fiscal_model.dart';
import 'package:sales_app/src/features/product/data/models/product_wallet_model.dart';
import 'package:sales_app/src/features/product/data/models/unit_model.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

@Entity()
class ProductModel {
  /// productId
  @Id(assignable: true)
  int id;

  int productId;
  String code;
  String name;
  String? description;
  int companyGroupId;


  final price = ToOne<MoneyModel>();
  final barcode = ToOne<BarcodeModel>();
  final categories = ToMany<CategoryModel>();
  final images = ToMany<ImageModel>();
  final packaging = ToMany<PackingModel>();
  final unit = ToOne<UnitModel>();
  final attributes = ToMany<AttributeModel>();
  final fiscal = ToOne<ProductFiscalModel>();

  // @Backlink('product')
  final wallets = ToMany<ProductWalletModel>();

  ProductModel ({
    this.id = 0,
    this.productId = 0,
    required this.code,
    required this.name,
    this.description,
    required this.companyGroupId
  });
}

extension ProductModelMapper on ProductModel {
  Product toEntity() {
    final modelBarcode = barcode.target;
    final packagingList = packaging.map((p) => p.toEntity()).toList();
    final categoriesList = categories.map((p) => p.toEntity()).toList();
    final imagesList = images.map((p) => p.toEntity()).toList();
    final attributesList = attributes.map((p) => p.toEntity()).toList();
    final walletsList = wallets.map((w) => w.toEntity()).toList();
    final modelPrice = price.target;
    final modelUnit = unit.target;
    final modelFiscal = fiscal.target;

    return Product.raw(
      productId: productId,
      code: code,
      name: name,
      companyGroupId: companyGroupId,
      price: modelPrice!.toEntity(), // Obrigatorio ter
      barcode: modelBarcode?.toEntity(),
      unit: modelUnit!.toEntity(), // Obrigatorio ter
      images: imagesList,
      categories: categoriesList,
      packings: packagingList,
      attributes: attributesList,
      description: description,
      fiscal: modelFiscal!.toEntity(), // Obrigatorio ter
      wallets: walletsList
    );
  }

  /// Remove este CustomerModel e todas as entidades relacionadas.
  void deleteRecursively({
    required Box<ProductModel> productBox,
    required Box<MoneyModel> moneyBox,
    required Box<BarcodeModel> barcodeBox,
    required Box<CategoryModel> categoryBox,
    required Box<ImageModel> imageBox,
    required Box<PackingModel> packingBox,
    required Box<UnitModel> unitBox,
    required Box<AttributeModel> attributeBox,
    required Box<AttributeValueModel> attributeValueBox,
    required Box<ProductFiscalModel> productFiscalBox,
    required Box<ProductWalletModel> productWalletBox
  }) {
    if (price.target != null) {
      moneyBox.remove(price.targetId);
    }

    if (barcode.target != null) {
      barcodeBox.remove(barcode.targetId);
    }

    for (final category in categories) {
      categoryBox.remove(category.id);
    }

    for (final image in images) {
      imageBox.remove(image.id);
    }

    for (final package in packaging) {
      package.deleteRecursively(packingBox: packingBox, barcodeBox: barcodeBox, unitBox: unitBox);
    }

    if (unit.target != null) {
      unitBox.remove(unit.targetId);
    }

    for (final attribute in attributes) {
      attribute.deleteRecursively(attributeBox: attributeBox, attributeValueBox: attributeValueBox, imageBox: imageBox, moneyBox: moneyBox);
    }

    if (fiscal.target != null) {
      productFiscalBox.remove(fiscal.targetId);
    }

    for (final wallet in wallets) {
      productWalletBox.remove(wallet.id);
    }

    productBox.remove(id);
  }
}

extension ProductMapper on Product {
  ProductModel toModel() {
    final entity = ProductModel(
      productId: productId,
      code: code,
      name: name,
      description: description,
      companyGroupId: companyGroupId
    );

    entity.unit.target = unit.toModel();
    entity.fiscal.target = fiscal.toModel();
    entity.price.target = price.toModel();

    if (barcode != null) {
      entity.barcode.target = barcode!.toModel();
    }
    if (images.isNotEmpty) {
      entity.images.addAll(images.map((i) => i.toModel()));
    }
    if (categories.isNotEmpty) {
      entity.categories.addAll(categories.map((c) => c.toModel()));
    }
    if (packings.isNotEmpty) {
      entity.packaging.addAll(packings.map((p) => p.toModel()));
    }
    if (attributes.isNotEmpty) {
      entity.attributes.addAll(attributes.map((p) => p.toModel()));
    }
    if (wallets.isNotEmpty) {
      entity.wallets.addAll(wallets.map((w) => w.toModel()));
    }

    return entity;
  }

  Product mapImages(ImageEntity Function(ImageEntity) transform) {
    return copyWith(
      images: images.map(transform).toList(),
      attributes: attributes
        .map((a) => a.mapImages(transform))
        .toList(),
    );
  }
}
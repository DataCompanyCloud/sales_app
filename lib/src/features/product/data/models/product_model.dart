import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/data/models/barcode_model.dart';
import 'package:sales_app/src/features/product/data/models/category_model.dart';
import 'package:sales_app/src/features/product/data/models/image_model.dart';
import 'package:sales_app/src/features/product/data/models/packing_model.dart';
import 'package:sales_app/src/features/product/data/models/attribute_model.dart';
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
  double price;

  final barcode = ToOne<BarcodeModel>();
  final category = ToMany<CategoryModel>();
  final image = ToMany<ImageModel>();
  final packing = ToMany<PackingModel>();
  final unit = ToOne<UnitModel>();
  final attributes = ToMany<AttributeModel>();

  ProductModel ({
    this.id = 0,
    this.productId = 0,
    required this.code,
    required this.name,
    this.description,
    required this.price
  });
}

extension ProductModelMapper on ProductModel {
  Product toEntity() {
    final modelBarcode = barcode.target;
    final modelUnit = unit.target;
    final packingList = packing.map((p) => p.toEntity()).toList();
    final categoryList = category.map((p) => p.toEntity()).toList();
    final imageList = image.map((p) => p.toEntity()).toList();
    final attributesList = attributes.map((p) => p.toEntity()).toList();

    return Product.raw(
      productId: productId,
      code: code,
      name: name,
      price: price,
      barcode: modelBarcode?.toEntity(),
      unit: modelUnit!.toEntity(),
      images: imageList,
      categories: categoryList,
      packings: packingList,
      attributes: attributesList,
      description: description
    );
  }
}

extension ProductMapper on Product {
  ProductModel toModel() {
    final entity = ProductModel(
      productId: productId,
      code: code,
      name: name,
      price: price,
      description: description
    );

    if (barcode != null) {
      entity.barcode.target = barcode!.toModel();
    }
    entity.unit.target = unit.toModel();
    if (images.isNotEmpty) {
      entity.image.addAll(images.map((i) => i.toModel()));
    }
    if (categories.isNotEmpty) {
      entity.category.addAll(categories.map((c) => c.toModel()));
    }
    if (packings.isNotEmpty) {
      entity.packing.addAll(packings.map((p) => p.toModel()));
    }
    if (attributes.isNotEmpty) {
      entity.attributes.addAll(attributes.map((p) => p.toModel()));
    }

    return entity;
  }
}
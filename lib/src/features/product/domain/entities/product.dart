import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/barcode.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/packing.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/property.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/unit.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/category.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const Product._();

  /// criar sem validação
  const factory Product.raw({
    required int productId,
    required String code,
    required String name,
    String? description,
    required double price,
    Barcode? barcode,
    required Unit unit,
    required List<ImageEntity> images,
    required List<Category> categories,
    required List<Packing> packings,
    required List<Property> properties
  }) = _Product;

  /// TODO Precisa fazer as validações somente quando as infromações forem diferentes de null!
  factory Product ({
    required int productId,
    required String code,
    required String name,
    String? description,
    required double price,
    Barcode? barcode,
    required Unit unit,
    required List<ImageEntity> images,
    required List<Category> categories,
    required List<Packing> packings,
    required List<Property> properties
  }) {
    if (name.trim().isEmpty) {
      throw AppException.errorUnexpected("Nome vazio");
    }

    return Product.raw(
      productId: productId,
      code: code,
      name: name,
      price: price,
      barcode: barcode,
      unit: unit,
      images: images,
      categories: categories,
      packings: packings,
      properties: properties,
      description: description
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
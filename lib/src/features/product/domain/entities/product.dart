import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/product/domain/entities/barcode.dart';
import 'package:sales_app/src/features/product/domain/entities/image.dart';
import 'package:sales_app/src/features/product/domain/entities/packing.dart';
import 'package:sales_app/src/features/product/domain/entities/unit.dart';
import 'package:sales_app/src/features/product/domain/entities/category.dart';

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
  }) {
    if (name.trim().isEmpty) {
      throw AppException.errorUnexpected("Nome vazio");
    }

    return Product.raw(productId: productId, code: code, name: name, price: price, barcode: barcode, unit: unit, images: images, categories: categories, packings: packings);
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}


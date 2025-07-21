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
  const Product._(); // permite métodos/fábricas custom

  /// criar um produto sem validação
  const factory Product.raw({
    required int id,
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

  /// cria validações
  factory Product ({
    required int id,
    required String code,
    required String name,
    String? description,
    required double price,
    Barcode? barcode,
    required Unit unit,
    required List<ImageEntity> images,
    required List<Category> categories,
    required List<Packing> packings,
  }){
    if (name.trim().isEmpty) {
      throw AppException.errorUnexpected("Nome vazio");
    }

    return Product.raw(id: id, code: code, name: name, price: price, unit: unit, images: images, categories: categories, packings: packings);
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}


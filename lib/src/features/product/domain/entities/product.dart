import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/barcode.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/packing.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/attribute.dart';
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
    required List<Attribute> attributes
  }) = _Product;

  /// TODO Precisa fazer as validações somente quando as informações forem diferentes de null!
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
    required List<Attribute> attributes
  }) {

    if (name.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "'Name' não pode ser vazio");
    }
    if (description == null) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "'Description' não pode ser nula");
    }
    if (barcode == null) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "'Barcode' não pode ser nulo");
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
      attributes: attributes,
      description: description
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);


  @JsonKey(includeFromJson: false)
  List<ImageEntity> get imagesAll => [...images, ...attributes.expand((a) => a.imagesAll)];

}

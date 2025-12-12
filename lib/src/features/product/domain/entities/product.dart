import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/barcode.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/packing.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/attribute.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/product_fiscal.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/product_wallet.dart';
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
    required int companyGroupId, // Representa qual empresa esse produto pertence
    String? description,
    required Money price,
    Barcode? barcode,
    required Unit unit,
    required List<ImageEntity> images,
    required List<Category> categories,
    required List<Packing> packings,
    required List<Attribute> attributes,
    required ProductFiscal fiscal,
    @Default([]) List<ProductWallet> wallets,
  }) = _Product;

  /// TODO Precisa fazer as validações somente quando as informações forem diferentes de null!
  factory Product ({
    required int productId,
    required String code,
    required String name,
    required int companyGroupId,
    String? description,
    required Money price,
    Barcode? barcode,
    required Unit unit,
    required List<ImageEntity> images,
    required List<Category> categories,
    required List<Packing> packings,
    required List<Attribute> attributes,
    required ProductFiscal fiscal,
    List<ProductWallet>? wallets,
  }) {
    if (name.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, " Nome do produto não pode ser vazio");
    }

    return Product.raw(
      productId: productId,
      code: code,
      name: name,
      companyGroupId: companyGroupId,
      price: price,
      barcode: barcode,
      unit: unit,
      images: images,
      categories: categories,
      packings: packings,
      attributes: attributes,
      description: description,
      fiscal: fiscal,
      wallets: wallets ?? []
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);


  /// Todas as imagens (produto + atributos)
  @JsonKey(includeFromJson: false)
  List<ImageEntity> get imagesAll => [...images, ...attributes.expand((a) => a.imagesAll)];


  ImageEntity? get imagePrimary {
    if (imagesAll.isEmpty) return null;
    return imagesAll.first;
  }
}

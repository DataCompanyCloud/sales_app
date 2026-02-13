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
import 'package:sales_app/src/features/product/domain/valueObjects/uom.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const Product._();

  /// criar sem validação
  const factory Product.raw({
    required int id,
    required String uuid,
    required String code,
    required String name,
    String? description,
    required Money price,
    String? externalId,
    Barcode? barcode,
    List<Packing>? packings,
    Uom? uom,
    required List<ImageEntity> images,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required bool isActive,
    required int companyGroupId, // Representa qual empresa esse produto pertence
    required Unit unit,
    required List<Category> categories,
    required List<Attribute> attributes,
    required ProductFiscal fiscal,
    @Default([]) List<ProductWallet> wallets,
  }) = _Product;

  /// TODO Precisa fazer as validações somente quando as informações forem diferentes de null!
  factory Product ({
    required int id,
    required String uuid,
    required String code,
    required String name,
    String? description,
    required Money price,
    String? externalId,
    Barcode? barcode,
    List<Packing>? packings,
    Uom? uom,
    required List<ImageEntity> images,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required bool isActive,
    required int companyGroupId,
    required Unit unit,
    required List<Category> categories,
    required List<Attribute> attributes,
    required ProductFiscal fiscal,
    List<ProductWallet>? wallets,
  }) {
    if (name.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, " Nome do produto não pode ser vazio");
    }

    return Product.raw(
      id: id,
      uuid: uuid,
      code: code,
      name: name,
      description: description,
      price: price,
      externalId: externalId,
      barcode: barcode,
      packings: packings,
      uom: uom,
      images: images,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      isActive: isActive,
      companyGroupId: companyGroupId,
      unit: unit,
      categories: categories,
      attributes: attributes,
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

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/product_fiscal.dart';

part 'sales_order_product.freezed.dart';
part 'sales_order_product.g.dart';

@freezed
abstract class SalesOrderProduct with _$SalesOrderProduct {
  const SalesOrderProduct._();

  const factory SalesOrderProduct.raw({
    required String productUuId,
    required int productId,
    required String productCode,
    required String productName,
    required double quantity,
    required Money unitPrice,
    ImageEntity? images,
    int? orderId,
    // @Default('UN') String unitOfMeasure, // Type
    @Default(Money.raw(amount: 0)) Money discountAmount,
    required ProductFiscal? fiscal
  }) = _SalesOrderProduct;


  factory SalesOrderProduct({
    required String productUuId,
    required int productId,
    required String productCode,
    required String productName,
    required double quantity,
    required Money unitPrice,
    ImageEntity? images,
    int? orderId,
    Money? discountAmount,
    required ProductFiscal? fiscal
  }) {

    //TODO fazer as validações
    if (productName.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Nome do produto não pode ser vazio");
    }

    if (quantity.isNegative) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Quantidade não pode ser um valor negativo");
    }

    return SalesOrderProduct.raw(
      productUuId: productUuId,
      productId: productId,
      productCode: productCode,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      images: images,
      orderId: orderId,
      discountAmount: discountAmount ?? const Money.raw(amount: 0),
      fiscal: fiscal
    );
  }


  factory SalesOrderProduct.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderProductFromJson(json);

/// Total da linha: qty*unit - discount + tax
// @JsonKey(ignore: true)
// Money get lineTotal => unitPrice;

  Money get totalValue => unitPrice.multiply(quantity);
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';

part 'order_product.freezed.dart';
part 'order_product.g.dart';

@freezed
abstract class OrderProduct with _$OrderProduct {
  const OrderProduct._();

  const factory OrderProduct.raw({
    required String productUuId,
    required int productId,
    required String productCode,
    required String name,
    required double quantity,
    required Money unitPrice,
    List<ImageEntity>? images,
    int? orderId,
    // @Default('UN') String unitOfMeasure, // Type
    @Default(Money.raw(amount: 0)) Money discountAmount,
    @Default(Money.raw(amount: 0)) Money taxAmount,
  }) = _OrderProduct;


  factory OrderProduct({
    required String productUuId,
    required int productId,
    required String productCode,
    required String name,
    required double quantity,
    required Money unitPrice,
    List<ImageEntity>? images,
    int? orderId,
    Money? discountAmount,
    Money? taxAmount,
  }) {

    //TODO fazer as validações
    if (name.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "'Name' não pode ser vazio");
    }
    if (quantity.isNegative) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "'Quantity' não pode ser um valor negativo");
    }

    return OrderProduct.raw(
      productUuId: productUuId,
      productId: productId,
      productCode: productCode,
      name: name,
      quantity: quantity,
      unitPrice: unitPrice,
      images: images,
      orderId: orderId,
      discountAmount: discountAmount ?? const Money.raw(amount: 0),
      taxAmount: taxAmount ?? const Money.raw(amount: 0),
    );
  }


  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

/// Total da linha: qty*unit - discount + tax
// @JsonKey(ignore: true)
// Money get lineTotal => unitPrice;

  Money get totalValue => unitPrice.multiply(quantity);
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';

part 'order_product.freezed.dart';
part 'order_product.g.dart';

@freezed
abstract class OrderProduct with _$OrderProduct {
  const OrderProduct._();

  const factory OrderProduct.raw({
    required String productUuId,
    required int productId,
    required String name,
    required double quantity,
    required Money unitPrice,
    int? orderId,
    // @Default('UN') String unitOfMeasure, // Type
    @Default(Money.raw(amount: 0)) Money discountAmount,
    @Default(Money.raw(amount: 0)) Money taxAmount,
  }) = _OrderProduct;


  factory OrderProduct({
    required String productUuId,
    required int productId,
    required String name,
    required double quantity,
    required Money unitPrice,
    int? orderId,
    Money discountAmount = const Money.raw(amount: 0),
    Money taxAmount = const Money.raw(amount: 0),
  }) {

    //TODO fazer as validações

    return OrderProduct.raw(
      productUuId: productUuId,
      productId: productId,
      name: name,
      quantity: quantity,
      unitPrice: unitPrice,
      orderId: orderId,
      discountAmount: discountAmount,
      taxAmount: taxAmount,
    );
  }


  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

/// Total da linha: qty*unit - discount + tax
// @JsonKey(ignore: true)
// Money get lineTotal => unitPrice;
}
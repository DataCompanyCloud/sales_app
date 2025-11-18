import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';

part 'sales_order_payment.freezed.dart';
part 'sales_order_payment.g.dart';

@freezed
abstract class SalesOrderPayment with _$SalesOrderPayment {
  const SalesOrderPayment._();

  const factory SalesOrderPayment.raw({
    required PaymentMethod paymentMethod,
    required Money money,
  }) = _SalesOrderPayment;

  factory SalesOrderPayment({
    required PaymentMethod paymentMethod,
    required Money money,
  }) {
    return SalesOrderPayment.raw(
      paymentMethod: paymentMethod,
      money: money
    );
  }

  factory SalesOrderPayment.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderPaymentFromJson(json);
}
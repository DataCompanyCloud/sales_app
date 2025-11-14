import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';

part 'sales_order_payment.freezed.dart';
part 'sales_order_payment.g.dart';

@freezed
abstract class SalesOrderPayment with _$SalesOrderPayment {
  const SalesOrderPayment._();

  const factory SalesOrderPayment.raw({
    PaymentMethod? paymentMethod,
    Money? money,
  }) = _SalesOrderPayment;

  factory SalesOrderPayment({
    PaymentMethod? paymentMethod,
    Money? money,
  }) {
    //TODO: Fazer as validações
    if (money == null) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "'Money' não pode ser nulo.");
    }
    if (money.decimalValue.isNegative) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "'Money' não pode ser um valor negativo.");
    }

    return SalesOrderPayment.raw(
      paymentMethod: paymentMethod,
      money: money
    );
  }

  factory SalesOrderPayment.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderPaymentFromJson(json);
}
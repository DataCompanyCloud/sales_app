// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
//
// part 'order_payment.freezed.dart';
// part 'order_payment.g.dart';
//
// @freezed
// abstract class OrderPayment with _$OrderPayment {
//   const OrderPayment._();
//
//   const factory OrderPayment.raw({
//     @Default(<PaymentMethod>[]) List<PaymentMethod> paymentMethod,
//     required Money money,
//   }) = _OrderPayment;
//
//   factory OrderPayment({
//     required List<PaymentMethod> paymentMethod,
//     required Money money,
//   }) {
//     //TODO: Fazer as validações
//
//     return OrderPayment.raw(
//       paymentMethod: paymentMethod,
//       money: money
//     );
//   }
//
//   factory OrderPayment.fromJson(Map<String, dynamic> json) =>
//       _$OrderPaymentFromJson(json);
// }
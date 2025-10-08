// import 'package:objectbox/objectbox.dart';
// import 'package:sales_app/src/features/customer/data/models/money_model.dart';
// import 'package:sales_app/src/features/customer/data/models/payment_method_model.dart';
// import 'package:sales_app/src/features/order/domain/entities/order_payment.dart';
//
// @Entity()
// class OrderPaymentModel {
//   @Id()
//   int id;
//
//   final orderPaymentList = ToMany<PaymentMethodModel>();
//   final money = ToOne<MoneyModel>();
//
//   OrderPaymentModel ({
//     this.id = 0,
//   });
// }
//
// extension OrderPaymentModeMapper on OrderPaymentModel {
//   /// De OrderPaymentModel → OrderPayment
//   OrderPayment toEntity() {
//     final paymentList = orderPaymentList.map((p) => p.toEntity()).toList();
//
//     return OrderPayment(
//       paymentMethod: paymentList,
//       money: money.target?.toEntity(),
//     );
//   }
// }
//
// extension OrderPaymentMapper on OrderPayment {
//   /// De OrderPayment → OrderPaymentModel
//   OrderPayment toModel() {
//     final model = OrderPaymentModel();
//
//     model.money.target = money.toModel();
//
//     return model;
//   }
// }
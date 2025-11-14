import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/payment_method_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order_payment.dart';

@Entity()
class OrderPaymentModel {
  @Id()
  int id;

  final paymentMethod = ToOne<PaymentMethodModel>();
  final money = ToOne<MoneyModel>();

  OrderPaymentModel ({
    this.id = 0,
  });
}

extension OrderPaymentModeMapper on OrderPaymentModel {
  /// De OrderPaymentModel → OrderPayment
  OrderPayment toEntity() {

    return OrderPayment(
      paymentMethod: paymentMethod.target?.toEntity(),
      money: money.target?.toEntity(),
    );
  }
}

extension OrderPaymentMapper on OrderPayment {
  /// De OrderPayment → OrderPaymentModel
  OrderPaymentModel toModel() {

    final model = OrderPaymentModel();

    model.paymentMethod.target = paymentMethod?.toModel();
    model.money.target = money?.toModel();

    return model;
  }
}
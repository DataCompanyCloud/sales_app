import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/payment_method_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_payment.dart';

@Entity()
class SalesOrderPaymentModel {
  @Id()
  int id;

  final paymentMethod = ToOne<PaymentMethodModel>();
  final money = ToOne<MoneyModel>();

  SalesOrderPaymentModel ({
    this.id = 0,
  });
}

extension SalesOrderPaymentModeMapper on SalesOrderPaymentModel {
  /// De OrderPaymentModel → OrderPayment
  SalesOrderPayment toEntity() {

    return SalesOrderPayment(
      paymentMethod: paymentMethod.target?.toEntity(),
      money: money.target?.toEntity(),
    );
  }
}

extension SalesOrderPaymentMapper on SalesOrderPayment {
  /// De OrderPayment → OrderPaymentModel
  SalesOrderPaymentModel toModel() {

    final model = SalesOrderPaymentModel();

    model.paymentMethod.target = paymentMethod?.toModel();
    model.money.target = money?.toModel();

    return model;
  }
}
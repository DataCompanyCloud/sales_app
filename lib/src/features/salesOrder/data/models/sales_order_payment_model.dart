import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_payment.dart';

@Entity()
class SalesOrderPaymentModel {
  @Id()
  int id;

  final int paymentMethod;
  final money = ToOne<MoneyModel>();

  SalesOrderPaymentModel ({
    this.id = 0,
    required this.paymentMethod
  });
}

extension SalesOrderPaymentModeMapper on SalesOrderPaymentModel {
  /// De OrderPaymentModel → OrderPayment
  SalesOrderPayment toEntity() {
    return SalesOrderPayment(
      paymentMethod: PaymentMethod.values[paymentMethod],
      money: money.target!.toEntity(),
    );
  }

  void deleteRecursively(
    Box<SalesOrderPaymentModel> salesOrderPaymentBox,
    Box<MoneyModel> moneyBox
  ) {

    if (money.target != null) {
      moneyBox.remove(money.targetId);
    }

    salesOrderPaymentBox.remove(id);
  }
}

extension SalesOrderPaymentMapper on SalesOrderPayment {
  /// De OrderPayment → OrderPaymentModel
  SalesOrderPaymentModel toModel() {
    final model = SalesOrderPaymentModel(
      paymentMethod: paymentMethod.index
    );

    model.money.target = money.toModel();

    return model;
  }
}
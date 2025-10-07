import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';

@Entity()
class PaymentMethodModel {
  @Id()
  int id;

  String label;

  PaymentMethodModel ({
    this.id = 0,
    required this.label
  });
}

extension PaymentMethodModelMapper on PaymentMethodModel {
  /// De PaymentMethodModel → PaymentMethod
  PaymentMethod toEntity() =>
      PaymentMethod.values.firstWhere(
        (e) => e.label == label,
        orElse: () => PaymentMethod.outros,
      );
}

extension PaymentMethodMapper on PaymentMethod {
  /// De PaymentMethod → PaymentMethodModel
  PaymentMethodModel toModel() => PaymentMethodModel(label: label);
}
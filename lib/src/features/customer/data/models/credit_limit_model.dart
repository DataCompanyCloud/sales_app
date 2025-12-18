import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/credit_limit.dart';

@Entity()
class CreditLimitModel{
  @Id()
  int id;

  final maximum = ToOne<MoneyModel>();
  final available = ToOne<MoneyModel>();

  CreditLimitModel({
    this.id = 0,
  });
}

extension CreditLimitModelMapper on CreditLimitModel {
  /// De MoneyModel → Money
  CreditLimit toEntity() => CreditLimit.raw(
    available: available.target!.toEntity(),
    maximum: maximum.target!.toEntity()
  );

  void deleteRecursively({
    required Box<CreditLimitModel> creditLimitBox,
    required Box<MoneyModel> moneyBox,
  }) {

    if (available.target != null) {
      moneyBox.remove(available.targetId);
    }

    if (maximum.target != null) {
      moneyBox.remove(available.targetId);
    }

    creditLimitBox.remove(id);
  }
}

extension CreditLimitMapper on CreditLimit {
  /// De Money → MoneyModel
  CreditLimitModel toModel() {
    final model = CreditLimitModel();

    model.maximum.target = maximum.toModel();
    model.available.target = available.toModel();

    return model;
  }
}
import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/currency.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';

@Entity()
class MoneyModel{
  @Id()
  int id;

  final int amount;
  final int currency;
  final int scale;

  MoneyModel({
    this.id = 0,
    required this.amount,
    required this.currency,
    required this.scale
  });
}

extension MoneyModelMapper on MoneyModel {
  /// De MoneyModel → Money
  Money toEntity() => Money(
    scale: scale,
    amount: amount,
    currency: Currency.values[currency]
  );
}

extension MoneyMapper on Money {
  /// De Money → MoneyModel
  MoneyModel toModel() => MoneyModel(
    amount: amount,
    currency: currency.index,
    scale: scale,
  );
}
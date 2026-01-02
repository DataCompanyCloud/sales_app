import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/product_tax_result.dart';

@Entity()
class ProductTaxResultModel {
  @Id()
  int id;

  @Index()
  final icmsBase = ToOne<MoneyModel>();
  final icmsValue = ToOne<MoneyModel>();
  double icmsAliquota;

  final icmsSTBase = ToOne<MoneyModel>();
  final icmsSTValue = ToOne<MoneyModel>();
  double? mva;

  final ipiBase = ToOne<MoneyModel>();
  final ipiValue = ToOne<MoneyModel>();
  double? ipiAliquota;

  final pisBase = ToOne<MoneyModel>();
  final pisValue = ToOne<MoneyModel>();
  double? pisAliquota;

  final cofinsBase = ToOne<MoneyModel>();
  final cofinsValue = ToOne<MoneyModel>();
  double? cofinsAliquota;

  final difalValue = ToOne<MoneyModel>();
  final fcpValue = ToOne<MoneyModel>();
  final totalTax = ToOne<MoneyModel>();


  ProductTaxResultModel ({
    this.id = 0,
    required this.icmsAliquota,
    required this.mva,
    required this.pisAliquota,
    required this.cofinsAliquota,
    required this.ipiAliquota
  });
}

extension ProductTaxResultModelMapper on ProductTaxResultModel {
  /// De ProductTaxResult → ProductTaxResult
  ProductTaxResult toEntity() {
    final modelIcmsBase = icmsBase.target;
    final modelIcmsValue = icmsValue.target;
    final modelIcsmSTBase = icmsSTBase.target;
    final modelIcmsSTValue = icmsSTValue.target;
    final modelIpiBase = ipiBase.target;
    final modelIpiValue = ipiValue.target;
    final modelPisBase = pisBase.target;
    final modelPisValue = pisValue.target;
    final modelCofinsBase = cofinsBase.target;
    final modelCofinsValue = cofinsValue.target;
    final modelDifalValue = difalValue.target;
    final modelFcpValue = fcpValue.target;
    final modelTotalTax = totalTax.target;

    return ProductTaxResult(
      icmsBase: modelIcmsBase!.toEntity(),
      icmsValue: modelIcmsValue!.toEntity(),
      icmsAliquota: Percentage(value: icmsAliquota),

      icmsSTBase: modelIcsmSTBase!.toEntity(),
      icmsSTValue: modelIcmsSTValue!.toEntity(),
      mva: mva != null ? Percentage(value: mva!) : null,

      ipiBase: modelIpiBase!.toEntity(),
      ipiValue: modelIpiValue!.toEntity(),
      ipiAliquota: ipiAliquota != null ? Percentage(value: ipiAliquota!) : null,

      pisBase: modelPisBase!.toEntity(),
      pisValue: modelPisValue!.toEntity(),
      pisAliquota: pisAliquota != null ? Percentage(value: ipiAliquota!) : null,

      cofinsBase: modelCofinsBase!.toEntity(),
      cofinsValue: modelCofinsValue!.toEntity(),
      cofinsAliquota: cofinsAliquota != null ? Percentage(value: cofinsAliquota!) : null,

      difalValue: modelDifalValue!.toEntity(),
      fcpValue: modelFcpValue!.toEntity(),
      totalTax: modelTotalTax!.toEntity()
    );
  }

  void deleteRecursively(
    Box<ProductTaxResultModel> productTaxResultBox,
    Box<MoneyModel> moneyBox
  ) {
    if(icmsBase.hasValue) moneyBox.remove(icmsBase.targetId);
    if(icmsValue.hasValue) moneyBox.remove(icmsValue.targetId);

    if(icmsSTBase.hasValue) moneyBox.remove(icmsSTBase.targetId);
    if(icmsSTValue.hasValue) moneyBox.remove(icmsSTValue.targetId);

    if(ipiBase.hasValue) moneyBox.remove(ipiBase.targetId);
    if(ipiValue.hasValue) moneyBox.remove(ipiValue.targetId);

    if(pisBase.hasValue) moneyBox.remove(pisBase.targetId);
    if(pisValue.hasValue) moneyBox.remove(pisValue.targetId);

    if(cofinsBase.hasValue) moneyBox.remove(cofinsBase.targetId);
    if(cofinsValue.hasValue) moneyBox.remove(cofinsValue.targetId);

    if(difalValue.hasValue) moneyBox.remove(difalValue.targetId);
    if(fcpValue.hasValue) moneyBox.remove(fcpValue.targetId);

    if(totalTax.hasValue) moneyBox.remove(totalTax.targetId);

    productTaxResultBox.remove(id);
  }
}

extension ProductTaxResultMapper on ProductTaxResult {
  /// De ProductTaxResult → ProductTaxResult
  ProductTaxResultModel toModel() {
    final model = ProductTaxResultModel(
      icmsAliquota: icmsAliquota.value,
      mva: mva?.value,
      pisAliquota: pisAliquota?.value,
      cofinsAliquota: cofinsAliquota?.value,
      ipiAliquota: ipiAliquota?.value
    );

    model.icmsBase.target = icmsBase.toModel();
    model.icmsValue.target = icmsValue.toModel();

    model.icmsSTBase.target = icmsSTBase.toModel();
    model.icmsSTValue.target = icmsSTValue.toModel();

    model.ipiBase.target = ipiBase.toModel();
    model.ipiValue.target = ipiValue.toModel();

    model.pisBase.target = pisBase.toModel();
    model.pisValue.target = pisValue.toModel();

    model.cofinsBase.target = cofinsBase.toModel();
    model.cofinsValue.target = cofinsValue.toModel();

    model.difalValue.target = difalValue.toModel();
    model.fcpValue.target = fcpValue.toModel();

    model.totalTax.target = totalTax.toModel();

    return model;
  }
}
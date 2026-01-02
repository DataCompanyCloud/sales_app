import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/data/models/product_fiscal_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/product_tax_result.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';

@Entity()
class SalesOrderProductModel {
  @Id()
  int id;

  @Index()
  String productUuId;
  int productId;
  String productCode;
  String name;
  double quantity;
  int? orderId;

  final unitPrice = ToOne<MoneyModel>();
  final discountAmount = ToOne<MoneyModel>();
  final fiscal = ToOne<ProductFiscalModel>();
  final taxResult = ToOne<ProductTaxResultModel>();

  SalesOrderProductModel ({
    this.id = 0,
    required this.productUuId,
    required this.productId,
    required this.productCode,
    required this.name,
    required this.quantity,
    this.orderId
  });
}

extension SalesOrderProductModelMapper on SalesOrderProductModel {
  /// De OrderProductModel → OrderProduct
  SalesOrderProduct toEntity() {
    final price = unitPrice.target?.toEntity();
    final modelFiscal = fiscal.target;
    final modelTaxResult = taxResult.target;

    return SalesOrderProduct(
      productUuId: productUuId,
      productId: productId,
      productCode: productCode,
      productName: name,
      quantity: quantity,
      unitPrice: price ?? const Money.raw(amount: 0),
      orderId: orderId,
      discountAmount: discountAmount.target?.toEntity(),
      fiscal: modelFiscal!.toEntity(),
      taxResult: modelTaxResult?.toEntity()
    );
  }

  void deleteRecursively(
    Box<SalesOrderProductModel> orderProductBox,
    Box<MoneyModel> moneyBox,
    Box<ProductFiscalModel> productFiscalBox,
    Box<ProductTaxResultModel> productTaxResultBox,
  ) {

    if (unitPrice.hasValue) {
      moneyBox.remove(unitPrice.targetId);
    }

    if (discountAmount.hasValue) {
      moneyBox.remove(discountAmount.targetId);
    }

    if (fiscal.hasValue) {
      productFiscalBox.remove(fiscal.targetId);
    }

    if (taxResult.hasValue) {
      productTaxResultBox.remove(taxResult.targetId);
    }

    orderProductBox.remove(id);
  }
}

extension SalesOrderProductMapper on SalesOrderProduct {
  /// De OrderProduct → OrderProductModel
  SalesOrderProductModel toModel() {

    final model = SalesOrderProductModel(
      productUuId: productUuId,
      productId: productId,
      productCode: productCode,
      name: productName,
      quantity: quantity,
      orderId: orderId
    );


    model.fiscal.target = fiscal.toModel();
    model.unitPrice.target = unitPrice.toModel();
    model.discountAmount.target = discountAmount.toModel();
    model.taxResult.target = taxResult?.toModel();

    return model;
  }
}
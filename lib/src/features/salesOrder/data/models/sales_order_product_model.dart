import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/data/models/product_fiscal_model.dart';
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

extension SalesOrderProductModeMapper on SalesOrderProductModel {
  /// De OrderProductModel → OrderProduct
  SalesOrderProduct toEntity() {
    final price = unitPrice.target?.toEntity();

    return SalesOrderProduct(
      productUuId: productUuId,
      productId: productId,
      productCode: productCode,
      productName: name,
      quantity: quantity,
      unitPrice: price ?? const Money.raw(amount: 0),
      orderId: orderId,
      discountAmount: discountAmount.target?.toEntity(),
      fiscal: fiscal.target?.toEntity()
    );
  }

  void deleteRecursively(
    Box<SalesOrderProductModel> orderProductBox,
    Box<MoneyModel> moneyBox,
    Box<ProductFiscalModel> productFiscalBox
  ) {

    if (unitPrice.target != null) {
      moneyBox.remove(unitPrice.targetId);
    }

    if (discountAmount.target != null) {
      moneyBox.remove(discountAmount.targetId);
    }

    if (fiscal.target != null) {
      productFiscalBox.remove(fiscal.targetId);
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


    model.fiscal.target = fiscal?.toModel();
    model.unitPrice.target = unitPrice.toModel();
    model.discountAmount.target = discountAmount.toModel();

    return model;
  }
}
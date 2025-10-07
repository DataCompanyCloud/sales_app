import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/order/domain/entities/order_product.dart';

@Entity()
class OrderProductModel {
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
  final taxAmount = ToOne<MoneyModel>();

  OrderProductModel ({
    this.id = 0,
    required this.productUuId,
    required this.productId,
    required this.productCode,
    required this.name,
    required this.quantity,
    this.orderId
  });
}

extension OrderProductModeMapper on OrderProductModel {
  /// De OrderProductModel → OrderProduct
  OrderProduct toEntity() {
    final price = unitPrice.target?.toEntity();

    return OrderProduct(
      productUuId: productUuId,
      productId: productId,
      productCode: productCode,
      name: name,
      quantity: quantity,
      unitPrice: price ?? const Money.raw(amount: 0),
      orderId: orderId,
      discountAmount: discountAmount.target?.toEntity(),
      taxAmount: taxAmount.target?.toEntity()
    );
  }
}

extension OrderProductMapper on OrderProduct {
  /// De OrderProduct → OrderProductModel
  OrderProductModel toModel() {

    final model = OrderProductModel(
      productUuId: productUuId,
      productId: productId,
      productCode: productCode,
      name: name,
      quantity: quantity,
      orderId: orderId
    );


    model.unitPrice.target = unitPrice.toModel();
    model.discountAmount.target = discountAmount.toModel();
    model.taxAmount.target = taxAmount.toModel();

    return model;
  }
}
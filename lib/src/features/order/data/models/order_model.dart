import 'package:sales_app/objectbox.g.dart' hide Order;
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/order/domain/entities/order_product.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/domain/valueObjects/order_status.dart';

@Entity()
class OrderModel {
  @Id(assignable: true)
  int id;

  int orderId;
  String orderUuId;
  String? orderCode;
  DateTime createdAt;
  int? serverId;
  int? customerId;
  String? customerName;
  OrderStatus status;
  DateTime? confirmedAt;
  DateTime? cancelledAt;
  String? notes;
  List<OrderProduct> items = const [];
  Money freight;
  Money itemsSubtotal;
  Money discountTotal;
  Money taxTotal;
  Money grandTotal;

  OrderModel({
    this.id = 0,
    required this.orderId,
    required this.orderUuId,
    required this.orderCode,
    required this.createdAt,
    required this.status,
    this.serverId,
    this.customerId,
    this.customerName,
    this.confirmedAt,
    this.cancelledAt,
    this.notes,
    this.items = const [],
    required this.freight,
    required this.itemsSubtotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.grandTotal,
  });
}

extension OrderModelMapper on OrderModel {
  Order toEntity() {
    return Order.raw(
      orderId: orderId,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      serverId: serverId,
      customerId: customerId,
      customerName: customerName,
      status: status,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes,
      items: items,
      freight: freight,
      itemsSubtotal: itemsSubtotal,
      discountTotal: discountTotal,
      taxTotal: taxTotal,
      grandTotal: grandTotal
    );
  }
}

extension OrderMapper on Order {
  OrderModel toModel() {
    final entity = OrderModel(
      orderId: orderId,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      serverId: serverId,
      customerId: customerId,
      customerName: customerName,
      status: status,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes,
      items: items,
      freight: freight,
      itemsSubtotal: itemsSubtotal,
      discountTotal: discountTotal,
      taxTotal: taxTotal,
      grandTotal: grandTotal,
    );

    return entity;
  }
}
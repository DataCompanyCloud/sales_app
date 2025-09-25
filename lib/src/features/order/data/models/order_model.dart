import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/order/data/models/order_product_model.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart' as domain;
import 'package:sales_app/src/features/order/domain/valueObjects/order_status.dart';

@Entity()
class OrderModel {
  @Id()
  int id;
  String orderUuId;
  String? orderCode;

  DateTime createdAt;
  int itemsCount;
  int? serverId;
  int? customerId;
  String? customerName;
  int status;
  DateTime? confirmedAt;
  DateTime? cancelledAt;
  String? notes;

  final freight = ToOne<MoneyModel>();
  final itemsSubtotal = ToOne<MoneyModel>();
  final discountTotal = ToOne<MoneyModel>();
  final taxTotal = ToOne<MoneyModel>();
  final grandTotal = ToOne<MoneyModel>();
  final items = ToMany<OrderProductModel>();

  OrderModel({
    this.id = 0,
    required this.orderUuId,
    required this.orderCode,
    required this.createdAt,
    required this.itemsCount,
    required this.status,
    this.serverId,
    this.customerId,
    this.customerName,
    this.confirmedAt,
    this.cancelledAt,
    this.notes,
  });
}

extension OrderModelMapper on OrderModel {
  domain.Order toEntity() {
    final itemsList = items.map((i) => i.toEntity()).toList();

    return domain.Order(
      orderId: id,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      serverId: serverId,
      customerId: customerId,
      customerName: customerName,
      status: OrderStatus.values[status],
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes,
      itemsCount: itemsCount,
      items: itemsList,
      freight: freight.target?.toEntity()
    );
  }
}

extension OrderMapper on domain.Order {
  OrderModel toModel() {
    final entity = OrderModel(
      id: orderId,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      itemsCount: itemsCount,
      serverId: serverId,
      customerId: customerId,
      customerName: customerName,
      status: status.index,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes
    );

    entity.freight.target = freight.toModel();

    if (items.isNotEmpty) {
      entity.items.addAll(items.map((i) => i.toModel()));
    }
    
    return entity;
  }
}
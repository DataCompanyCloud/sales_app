import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/payment_method_model.dart';
import 'package:sales_app/src/features/order/data/models/order_customer_model.dart';
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
  final customer = ToOne<OrderCustomerModel>();
  final items = ToMany<OrderProductModel>();
  final paymentMethods = ToMany<PaymentMethodModel>();

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
    final payments = paymentMethods.map((p) => p.toEntity()).toList();
    final customers = customer.target?.toEntity();

    return domain.Order(
      orderId: id,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      serverId: serverId,
      status: OrderStatus.values[status],
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes,
      itemsCount: itemsCount,
      items: itemsList,
      paymentMethod: payments,
      customer: customers,
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
      status: status.index,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes
    );

    entity.freight.target = freight.toModel();
    entity.customer.target = customer?.toModel();

    if (items.isNotEmpty) {
      entity.items.addAll(items.map((i) => i.toModel()));
    }



    return entity;
  }
}
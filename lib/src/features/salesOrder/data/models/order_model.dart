import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/payment_method_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/salesOrder/data/models/order_customer_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/order_payment_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/order_product_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order.dart' as domain;
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/order_status.dart';

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
  DateTime? updatedAt;
  DateTime? syncedAt;
  DateTime? confirmedAt;
  DateTime? cancelledAt;
  String? notes;
  bool needsSync;

  final total = ToOne<MoneyModel>();
  final freight = ToOne<MoneyModel>();
  final customer = ToOne<OrderCustomerModel>();
  final items = ToMany<OrderProductModel>();
  final paymentMethods = ToMany<PaymentMethodModel>();
  final orderPayment = ToMany<OrderPaymentModel>();



  OrderModel({
    this.id = 0,
    required this.orderUuId,
    required this.orderCode,
    required this.createdAt,
    required this.itemsCount,
    required this.status,
    required this.needsSync,
    this.serverId,
    this.customerId,
    this.customerName,
    this.updatedAt,
    this.syncedAt,
    this.confirmedAt,
    this.cancelledAt,
    this.notes
  });
}

extension OrderModelMapper on OrderModel {
  domain.Order toEntity() {
    final itemsList = items.map((i) => i.toEntity()).toList();
    final payments = paymentMethods.map((p) => p.toEntity()).toList();
    final customers = customer.target?.toEntity();
    final orderPaymentList = orderPayment.map((o) => o.toEntity()).toList();

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
      total: total.target?.toEntity() ?? Money.zero(),
      items: itemsList,
      orderPayment: orderPaymentList,
      paymentMethods: payments,
      customer: customers,
      freight: freight.target?.toEntity()
    );
  }
}

extension OrderMapper on domain.Order {
  bool get isPendingSync {
    // nunca sincronizado
    if (serverId == null) return true;

    // sincronizado mas depois atualizado
    if (updatedAt != null && syncedAt != null) {
      return updatedAt!.isAfter(syncedAt!);
    }

    return false;
  }
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
      needsSync: isPendingSync,
      notes: notes
    );

    entity.freight.target = freight.toModel();
    entity.customer.target = customer?.toModel();
    entity.total.target = total.toModel();

    if (items.isNotEmpty) {
      entity.items.addAll(items.map((i) => i.toModel()));
    }


    return entity;
  }
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/order/domain/entities/order_product.dart';
import 'package:sales_app/src/features/order/domain/valueObjects/order_status.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const Order._();

  const factory Order.raw({
    required int orderId,
    required String orderUuId,
    required String? orderCode,
    required DateTime createdAt,
    int? serverId,
    int? customerId,
    String? customerName,
    @Default(OrderStatus.draft) OrderStatus status,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? notes,
    @Default(Money.raw(amount: 0)) Money freight, /// Frete
    @Default(<OrderProduct>[]) List<OrderProduct> items, /// Itens
    /// Totais armazenados (opcionalmente sincronizados via 'recalculate')
    @Default(Money.raw(amount: 0)) Money itemsSubtotal,
    @Default(Money.raw(amount: 0)) Money discountTotal,
    @Default(Money.raw(amount: 0)) Money taxTotal,
    @Default(Money.raw(amount: 0)) Money grandTotal,
  }) = _Order;

  factory Order({
    required int orderId,
    required String orderUuId,
    required String? orderCode,
    required DateTime createdAt,
    int? serverId,
    int? customerId,
    String? customerName,
    OrderStatus status = OrderStatus.draft,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? notes,
    List<OrderProduct> items = const [], /// Itens
    Money freight = const Money.raw(amount: 0), /// Frete
    /// Totais armazenados (opcionalmente sincronizados via 'recalculate')
    Money itemsSubtotal = const Money.raw(amount: 0),
    Money discountTotal = const Money.raw(amount: 0),
    Money taxTotal = const Money.raw(amount: 0),
    Money grandTotal = const Money.raw(amount: 0),
  }) {

    //TODO fazer as validações

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


  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  // @JsonKey(includeFromJson: false)
  // Money get calcItemsSubtotal => items.fold(
  //   moneyZero(currency: currency, scale: scale),
  //   (acc, it) => acc.plus(it.unitPrice.timesQty(it.quantity)),
  // );
  //
  // @JsonKey(includeFromJson: false)
  // Money get calcDiscountTotal => items.fold(
  //   moneyZero(currency: currency, scale: scale),
  //   (acc, it) => acc.plus(it.discountAmount),
  // );
  //
  // @JsonKey(includeFromJson: false)
  // Money get calcTaxTotal => items.fold(
  //   moneyZero(currency: currency, scale: scale),
  //   (acc, it) => acc.plus(it.taxAmount),
  // );
  //
  // @JsonKey(includeFromJson: false)
  // Money get calcGrandTotal =>
  //   calcItemsSubtotal.minus(calcDiscountTotal).plus(calcTaxTotal).plus(freight);
  //
  // Order recalculate() => copyWith(
  //   itemsSubtotal: calcItemsSubtotal,
  //   discountTotal: calcDiscountTotal,
  //   taxTotal: calcTaxTotal,
  //   grandTotal: calcGrandTotal
  // );
}
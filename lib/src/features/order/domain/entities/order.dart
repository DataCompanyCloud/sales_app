import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/features/order/domain/entities/order_customer.dart';
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
    required itemsCount,
    OrderCustomer? customer,
    int? serverId,
    @Default(OrderStatus.draft) OrderStatus status,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? notes,
    @Default([]) List<PaymentMethod> paymentMethods,
    @Default(Money.raw(amount: 0)) Money freight, /// Frete
    @Default(<OrderProduct>[]) List<OrderProduct> items, /// Itens
    /// Totais armazenados (opcionalmente sincronizados via 'recalculate')
    @Default(Money.raw(amount: 0)) Money itemsSubtotal,
    @Default(Money.raw(amount: 0)) Money discountTotal,
    @Default(Money.raw(amount: 0)) Money taxTotal,
    @Default(Money.raw(amount: 0)) Money grandTotal
  }) = _Order;

  factory Order({
    required int orderId,
    required String orderUuId,
    required String? orderCode,
    required DateTime createdAt,
    required int itemsCount,
    required List<OrderProduct> items,
    // required List<PaymentMethod> paymentMethod,
    OrderCustomer? customer,
    int? serverId,
    OrderStatus status = OrderStatus.draft,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? notes,
    Money? freight, /// Frete
  }) {

    //TODO fazer as validações
    if (confirmedAt != null && confirmedAt.isBefore(createdAt)) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Um pedido não pode ser confirmado antes de sua criação");
    }
    if (cancelledAt != null && cancelledAt.isBefore(createdAt)) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Um pedido não pode ser cancelado antes de sua criação");
    }
    if (confirmedAt != null && cancelledAt != null && cancelledAt.isBefore(confirmedAt)) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Um pedido não pode ser cancelado antes de ser confirmado");
    }
    if (cancelledAt != null && confirmedAt != null && confirmedAt.isAfter(cancelledAt)) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Não é possível confirmar um pedido já cancelado");
    }

    return Order.raw(
      orderId: orderId,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      serverId: serverId,
      status: status,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes,
      itemsCount: itemsCount,
      customer: customer,
      items: items,
      // paymentMethods: paymentMethod,
      freight: freight ?? Money.zero(),
      //TODO Mudar isso aqui
      itemsSubtotal: Money.zero(),
      discountTotal: Money.zero(),
      taxTotal: Money.zero(),
      grandTotal: Money.zero(),
    );
  }


  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  @JsonKey(includeFromJson: false)
  Money get calcItemsSubtotal => items.fold(
    Money.zero(),
    (acc, it) => acc.plus(it.unitPrice.multiply(it.quantity)),
  );

  @JsonKey(includeFromJson: false)
  Money get calcDiscountTotal => items.fold(
    Money.zero(),
    (acc, it) => acc.plus(it.discountAmount),
  );

  @JsonKey(includeFromJson: false)
  Money get calcTaxTotal => items.fold(
    Money.zero(),
    (acc, it) => acc.plus(it.taxAmount),
  );

  @JsonKey(includeFromJson: false)
  Money get calcGrandTotal => calcItemsSubtotal.minus(calcDiscountTotal).plus(calcTaxTotal).plus(freight);


  // Funções
  Order recalculate() => copyWith(
    itemsSubtotal: calcItemsSubtotal,
    discountTotal: calcDiscountTotal,
    taxTotal: calcTaxTotal,
    grandTotal: calcGrandTotal
  );

  Order confirmed() => copyWith(
    status: OrderStatus.confirmed,
    confirmedAt: DateTime.now()
  );

  Order cancelled() => copyWith(
    status: OrderStatus.cancelled,
    cancelledAt: DateTime.now()
  );
}
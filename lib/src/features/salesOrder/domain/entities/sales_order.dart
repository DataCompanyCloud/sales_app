import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_company_group.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_customer.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_payment.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/sales_order_status.dart';

part 'sales_order.freezed.dart';
part 'sales_order.g.dart';

@freezed
abstract class SalesOrder with _$SalesOrder {
  const SalesOrder._();

  const factory SalesOrder.raw({
    required int orderId,
    required String orderUuId,
    required String? orderCode,
    required DateTime createdAt,
    required int itemsCount,
    required Money total,
    SalesOrderCustomer? customer,
    int? serverId,
    @Default(SalesOrderStatus.draft) SalesOrderStatus status,
    DateTime? updatedAt,
    DateTime? syncedAt,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? notes,
    @Default([]) List<SalesOrderPayment> orderPaymentMethods,
    @Default([]) List<SalesOrderCompanyGroup> companyGroup,
    @Default(Money.raw(amount: 0)) Money? freight, /// Frete
    /// Itens
    /// Totais armazenados (opcionalmente sincronizados via 'recalculate')
    @Default(Money.raw(amount: 0)) Money itemsSubtotal,
    @Default(Money.raw(amount: 0)) Money discountTotal,
    @Default(Money.raw(amount: 0)) Money taxTotal,
    @Default(Money.raw(amount: 0)) Money grandTotal
  }) = _SalesOrder;

  factory SalesOrder({
    required int orderId,
    required String orderUuId,
    required String? orderCode,
    required DateTime createdAt,
    required int itemsCount,
    required Money total,
    required List<SalesOrderPayment> orderPaymentMethods,
    required List<SalesOrderCompanyGroup> companyGroup,
    SalesOrderCustomer? customer,
    int? serverId,
    SalesOrderStatus status = SalesOrderStatus.draft,
    DateTime? updatedAt,
    DateTime? syncedAt,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? notes,
    Money? freight, /// Frete
  }) {

    //TODO fazer as validações
    if (confirmedAt != null && confirmedAt.isBefore(createdAt)) {
      throw AppException(AppExceptionCode.CODE_050_ORDER_CANNOT_BE_CONFIRMED_BEFORE_CREATION, "Um pedido não pode ser confirmado antes de sua criação");
    }
    if (cancelledAt != null && cancelledAt.isBefore(createdAt)) {
      throw AppException(AppExceptionCode.CODE_051_ORDER_CANNOT_BE_CANCELLED_BEFORE_CREATION, "Um pedido não pode ser cancelado antes de sua criação");
    }
    if (confirmedAt != null && cancelledAt != null && cancelledAt.isBefore(confirmedAt)) {
      throw AppException(AppExceptionCode.CODE_052_ORDER_CANNOT_BE_CANCELLED_BEFORE_CONFIRMED, "Um pedido não pode ser cancelado antes de ser confirmado");
    }
    if (cancelledAt != null && confirmedAt != null && confirmedAt.isAfter(cancelledAt)) {
      throw AppException(AppExceptionCode.CODE_053_ORDER_ALREADY_CANCELED_CANNOT_CONFIRM, "Não é possível confirmar um pedido já cancelado");
    }

    return SalesOrder.raw(
      orderId: orderId,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      serverId: serverId,
      status: status,
      updatedAt: updatedAt,
      syncedAt: syncedAt,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes,
      itemsCount: itemsCount,
      total: total,
      orderPaymentMethods: orderPaymentMethods,
      customer: customer,
      freight: freight ?? Money.zero(),
      companyGroup: companyGroup,
      //TODO Mudar isso aqui
      itemsSubtotal: Money.zero(),
      discountTotal: Money.zero(),
      taxTotal: Money.zero(),
      grandTotal: Money.zero(),
    );
  }


  factory SalesOrder.fromJson(Map<String, dynamic> json) => _$SalesOrderFromJson(json);

  @JsonKey(includeFromJson: false)
  List<SalesOrderProduct> get items =>
      companyGroup.expand((g) => g.items).toList();

  @JsonKey(includeFromJson: false)
  Money get _calcItemsSubtotal => items.fold(
    Money.zero(),
    (acc, it) => acc.plus(it.unitPrice.multiply(it.quantity)),
  );

  @JsonKey(includeFromJson: false)
  Money get calcItemsSubtotal => _calcItemsSubtotal == Money.zero()
    ? total
    : _calcItemsSubtotal
  ;

  @JsonKey(includeFromJson: false)
  Money get calcDiscountTotal => items.fold(
    Money.zero(),
    (acc, it) => acc.plus(it.discountAmount),
  );

  @JsonKey(includeFromJson: false)
  Money get calcGrandTotal => calcItemsSubtotal.minus(calcDiscountTotal).plus(freight!);

  // Funções
  SalesOrder recalculate() => copyWith(
    itemsSubtotal: calcItemsSubtotal,
    discountTotal: calcDiscountTotal,
    grandTotal: calcGrandTotal
  );

  SalesOrder confirmed() => copyWith(
    status: SalesOrderStatus.confirmed,
    confirmedAt: DateTime.now()
  );

  SalesOrder cancelled() => copyWith(
    status: SalesOrderStatus.cancelled,
    cancelledAt: DateTime.now()
  );

  SalesOrder updateCustomer(Customer? newCustomer) {
    return copyWith(
      customer: newCustomer == null ? null : SalesOrderCustomer.fromCustomer(newCustomer),
      updatedAt: DateTime.now()
    );
  }

  SalesOrder updateCustomerAddress(Address? address) {
    return copyWith(
      customer: customer?.copyWith(address: address),
      updatedAt: DateTime.now()
    );
  }

  SalesOrder updateCustomerContact(ContactInfo? contact) {
    return copyWith(
      customer: customer?.copyWith(contactInfo: contact),
      updatedAt: DateTime.now()
    );
  }

}
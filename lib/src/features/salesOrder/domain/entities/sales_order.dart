import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
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
    @Default(Money.raw(amount: 0)) Money freight, /// Frete
    @Default(<SalesOrderProduct>[]) List<SalesOrderProduct> items, /// Itens
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
    required List<SalesOrderProduct> items,
    required List<SalesOrderPayment> orderPaymentMethods,
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
      items: items,
      freight: freight ?? Money.zero(),
      //TODO Mudar isso aqui
      itemsSubtotal: Money.zero(),
      discountTotal: Money.zero(),
      taxTotal: Money.zero(),
      grandTotal: Money.zero(),
    );
  }


  factory SalesOrder.fromJson(Map<String, dynamic> json) => _$SalesOrderFromJson(json);


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
  Money get calcTaxTotal => items.fold(
    Money.zero(),
    (acc, it) => acc.plus(it.taxAmount),
  );

  @JsonKey(includeFromJson: false)
  Money get calcGrandTotal => calcItemsSubtotal.minus(calcDiscountTotal).plus(calcTaxTotal).plus(freight);

  // Funções
  SalesOrder recalculate() => copyWith(
    itemsSubtotal: calcItemsSubtotal,
    discountTotal: calcDiscountTotal,
    taxTotal: calcTaxTotal,
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

  SalesOrder updateItems(List<SalesOrderProduct> items) {
    return copyWith(
      items: items,
      itemsCount: items.length,
      updatedAt: DateTime.now()
    );
  }

  SalesOrder addItem(SalesOrderProduct salesOrderProduct) {
    // cria uma cópia da lista atual
    final newItems = [...items];

    // procura se já existe um item desse produto
    final index = newItems.indexWhere(
          (item) => item.productId == salesOrderProduct.productId,
    );

    if (index == -1) {
      // não existe -> adiciona novo
      newItems.add(salesOrderProduct);
    } else {
      // já existe -> soma a quantidade
      final existing = newItems[index];
      newItems[index] = existing.copyWith(
        quantity: existing.quantity + salesOrderProduct.quantity,
      );
    }

    return copyWith(
      items: newItems,
      itemsCount: newItems.length,
      updatedAt: DateTime.now(),
    );
  }

  SalesOrder subtractItem(SalesOrderProduct salesOrderProduct) {
    final newItems = [...items];

    final index = newItems.indexWhere(
        (item) => item.productId == salesOrderProduct.productId,
    );

    if (index == -1) {
      // não tem esse item no pedido, não faz nada
      return this;
    }

    final existing = newItems[index];
    final newQuantity = existing.quantity - salesOrderProduct.quantity;

    if (newQuantity > 0) {
      // ainda sobra quantidade -> atualiza
      newItems[index] = existing.copyWith(
        quantity: newQuantity,
      );
    } else {
      // zerou ou ficou negativo -> remove da lista
      newItems.removeAt(index);
    }

    return copyWith(
      items: newItems,
      itemsCount: newItems.length,
      updatedAt: DateTime.now(),
    );
  }

  SalesOrder removeItem(SalesOrderProduct salesOrderProduct) {
    final newItems = items
        .where((item) => item.productId != salesOrderProduct.productId)
        .toList();

    // se nada mudou, retorna o mesmo objeto
    if (newItems.length == items.length) {
      return this;
    }

    return copyWith(
      items: newItems,
      itemsCount: newItems.length,
      updatedAt: DateTime.now(),
    );
  }
}
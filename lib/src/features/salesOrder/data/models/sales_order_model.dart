import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/data/models/product_fiscal_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/product_tax_result.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_company_group_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_customer_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_payment_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_product_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/tax_context_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/sales_order_status.dart';

@Entity()
class SalesOrderModel {
  @Id()
  int id;
  String orderUuId;
  String? orderCode;

  @Property(type: PropertyType.date)
  DateTime createdAt;
  int itemsCount;
  int? serverId;
  int? customerId;
  String? customerName;
  int status;
  @Property(type: PropertyType.date)
  DateTime? updatedAt;
  @Property(type: PropertyType.date)
  DateTime? syncedAt;
  @Property(type: PropertyType.date)
  DateTime? confirmedAt;
  @Property(type: PropertyType.date)
  DateTime? cancelledAt;
  String? notes;
  bool needsSync;

  final total = ToOne<MoneyModel>();
  final freight = ToOne<MoneyModel>();
  final customer = ToOne<SalesOrderCustomerModel>();
  final companiesGroup = ToMany<SalesOrderCompanyGroupModel>();
  final orderPaymentMethods = ToMany<SalesOrderPaymentModel>();

  SalesOrderModel({
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

extension SalesOrderModelMapper on SalesOrderModel {
  SalesOrder toEntity() {
    final companiesGroupList = companiesGroup.map((i) => i.toEntity()).toList();
    final customers = customer.target?.toEntity();
    final orderPaymentList = orderPaymentMethods.map((o) => o.toEntity()).toList();
    final modelTotal = total.target;
    final modelFreight = freight.target;

    return SalesOrder(
      orderId: id,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      syncedAt: syncedAt,
      updatedAt: updatedAt,
      serverId: serverId,
      status: SalesOrderStatus.values[status],
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      notes: notes,
      itemsCount: itemsCount,
      total: modelTotal?.toEntity() ?? Money.zero(),
      orderPaymentMethods: orderPaymentList,
      companyGroup: companiesGroupList,
      customer: customers,
      freight: modelFreight?.toEntity()
    );
  }


  void deleteRecursively({
    required Box<SalesOrderModel> salesOrderBox,
    required Box<SalesOrderCustomerModel> salesOrderCustomerBox,
    required Box<SalesOrderPaymentModel> salesOrderPaymentBox,
    required Box<SalesOrderProductModel> salesOrderProductBox,
    required Box<SalesOrderCompanyGroupModel> salesOrderCompanyGroupBox,
    required Box<ContactInfoModel> contactInfoBox,
    required Box<MoneyModel> moneyBox,
    required Box<PhoneModel> phoneBox,
    required Box<AddressModel> addressBox,
    required Box<ProductFiscalModel> productFiscalBox,
    required Box<TaxContextModel> taxContextBox,
    required Box<ProductTaxResultModel> productTaxResultBox,
  }) {

    if (total.target != null) {
      moneyBox.remove(total.targetId);
    }

    if (freight.target != null) {
      moneyBox.remove(freight.targetId);
    }

    final salesCustomer = customer.target;
    if (salesCustomer != null) {
      salesCustomer.deleteRecursively(salesOrderCustomerBox, contactInfoBox, phoneBox, addressBox);
    }

    for (final payment in orderPaymentMethods) {
      payment.deleteRecursively(salesOrderPaymentBox, moneyBox);
    }

    for (final companyGroup in companiesGroup) {
      companyGroup.deleteRecursively(
        salesOrderCompanyGroupBox: salesOrderCompanyGroupBox,
        salesOrderProductBox: salesOrderProductBox,
        moneyBox: moneyBox,
        productFiscalBox: productFiscalBox,
        taxContextModel: taxContextBox,
        productTaxResultBox: productTaxResultBox
      );
    }

    salesOrderBox.remove(id);
  }
}

extension SalesOrderMapper on SalesOrder {
  bool get isPendingSync {
    // nunca sincronizado
    if (serverId == null) return true;

    // sincronizado mas depois atualizado
    if (updatedAt != null && syncedAt != null) {
      return updatedAt!.isAfter(syncedAt!);
    }

    return false;
  }
  SalesOrderModel toModel() {
    final entity = SalesOrderModel(
      id: orderId,
      orderUuId: orderUuId,
      orderCode: orderCode,
      createdAt: createdAt,
      itemsCount: itemsCount,
      serverId: serverId,
      status: status.index,
      updatedAt: updatedAt,
      syncedAt: syncedAt,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
      needsSync: isPendingSync,
      notes: notes,
    );

    entity.freight.target = freight.toModel();
    entity.customer.target = customer?.toModel();
    entity.total.target = total.toModel();

    if (companyGroup.isNotEmpty) {
      entity.companiesGroup.addAll(companyGroup.map((c) => c.toModel()));
    }

    return entity;
  }
}
import 'dart:async';
import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_customer_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_payment_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_product_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/sales_order_repository.dart';

class SalesOrderRepositoryImpl extends SalesOrderRepository {
  final Store store;

  SalesOrderRepositoryImpl(this.store);

  @override
  Future<List<SalesOrder>> fetchAll(SalesOrderFilter filter) async {
    final box = store.box<SalesOrderModel>();
    Condition<SalesOrderModel>? cond;

    // Texto
    final raw = filter.q?.trim();
    if (raw != null && raw.isNotEmpty) {
      cond = SalesOrderModel_.customerName.contains(raw, caseSensitive: false) | SalesOrderModel_.orderCode.contains(raw, caseSensitive: false);
    }

    if (filter.status != null) {
      final statusCond = SalesOrderModel_.status.equals(filter.status!.index);
      cond = (cond == null) ? statusCond : (cond & statusCond);
    }

    if (filter.onlyPendingSync) {
      final pendingCond = SalesOrderModel_.needsSync.equals(true);
      cond = (cond == null) ? pendingCond : (cond & pendingCond);
    }

    final qb = (cond == null) ? box.query() : box.query(cond);

    final order = filter.direction == SortDirection.desc ? Order.descending: 0;
    switch (filter.orderBy) {
      case SalesOrderSortField.createdAt: qb.order(SalesOrderModel_.createdAt, flags: order);
        break;
      case SalesOrderSortField.updatedAt: qb.order(SalesOrderModel_.updatedAt, flags: order);
        break;
      case SalesOrderSortField.total: qb.order(SalesOrderModel_.total, flags: order);
        break;
      case SalesOrderSortField.customerName: qb.order(SalesOrderModel_.customerName, flags: order);
        break;
      case SalesOrderSortField.itemsCount: qb.order(SalesOrderModel_.itemsCount, flags: order);
        break;
    }
    
    final q = qb.build();
    try {
      final models = await q.findAsync();
      return models.map((m) => m.toEntity()).toList();
    } finally {
      q.close();
    }
  }

  @override
  Future<SalesOrder> fetchById(int orderId) async {
    try {
      final orderBox = store.box<SalesOrderModel>();

      final model = await orderBox.getAsync(orderId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Pedido não encontrado");
      }

      return model.toEntity();
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }

  @override
  Future<void> saveAll(List<SalesOrder> orders) async {
    final orderBox = store.box<SalesOrderModel>();
    final orderCustomerBox = store.box<SalesOrderCustomerModel>();
    final orderProductBox = store.box<OrderProductModel>();
    final contactInfoBox = store.box<ContactInfoModel>();
    final moneyBox = store.box<MoneyModel>();

    store.runInTransaction(TxMode.write, () {
      for (final order in orders) {
        final existingQ = orderBox.query(SalesOrderModel_.orderUuId.equals(order.orderUuId)).build();
        final existing  = existingQ.findFirst();
        existingQ.close();

        final newModel = order.toModel();
        if (existing != null) {
          final total = existing.total.target;
          if (total != null) {
            moneyBox.remove(total.id);
          }

            final freight = existing.freight.target;
          if (freight != null) {
            moneyBox.remove(freight.id);
          }

          final customer = existing.customer.target;
          if (customer != null){

            for (final items in customer.contactInfo) {
              contactInfoBox.remove(items.id);
            }

            orderCustomerBox.remove(existing.customer.targetId);
          }

          for (final items in existing.items) {

            final unitPrice = items.unitPrice.target;
            if (unitPrice != null) {
              moneyBox.remove(unitPrice.id);
            }

            final discountAmount = items.discountAmount.target;
            if (discountAmount != null) {
              moneyBox.remove(discountAmount.id);
            }

            final taxAmount = items.taxAmount.target;
            if (taxAmount != null) {
              moneyBox.remove(taxAmount.id);
            }

            orderProductBox.remove(items.id);
          }

          newModel.id = existing.id;
        } else {
          newModel.id = 0;
        }

        orderBox.put(newModel);
      }
    });
  }

  @override
  Future<SalesOrder> save(SalesOrder order) async {
    final salesOrderBox = store.box<SalesOrderModel>();
    final salesOrderCustomerBox = store.box<SalesOrderCustomerModel>();
    final salesOrderPaymentBox = store.box<SalesOrderPaymentModel>();
    final salesOrderProductBox = store.box<OrderProductModel>();
    final contactInfoBox = store.box<ContactInfoModel>();
    final moneyBox = store.box<MoneyModel>();
    final phoneBox = store.box<PhoneModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existingQ = salesOrderBox.query(SalesOrderModel_.orderUuId.equals(order.orderUuId)).build();
      final existing  = existingQ.findFirst();
      existingQ.close();

      final newModel = order.toModel();

      newModel.id = existing?.id ?? 0;
      if (existing != null) {
        existing.deleteRecursively(
          salesOrderBox,
          salesOrderCustomerBox,
          salesOrderPaymentBox,
          salesOrderProductBox,
          contactInfoBox,
          moneyBox,
          phoneBox
        );
      }

      // Importante: put() cuidará de persistir ToOne/ToMany que você setou em newModel
      return salesOrderBox.put(newModel);
    });

    final saved = await salesOrderBox.getAsync(id);
    if (saved == null) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Pedido não encontrado após sua inserção");
    }
    return saved.toEntity();
  }

  @override
  Future<void> delete(SalesOrder order) async {
    final salesOrderBox = store.box<SalesOrderModel>();
    final salesOrderCustomerBox = store.box<SalesOrderCustomerModel>();
    final salesOrderPaymentBox = store.box<SalesOrderPaymentModel>();
    final salesOrderProductBox = store.box<OrderProductModel>();
    final contactInfoBox = store.box<ContactInfoModel>();
    final moneyBox = store.box<MoneyModel>();
    final phoneBox = store.box<PhoneModel>();

    store.runInTransaction(TxMode.write, () {
      final model = salesOrderBox.get(order.orderId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Pedido não encontrado");
      }

      model.deleteRecursively(
        salesOrderBox,
        salesOrderCustomerBox,
        salesOrderPaymentBox,
        salesOrderProductBox,
        contactInfoBox,
        moneyBox,
        phoneBox
      );
    });
  }

  @override
  Future<void> deleteAll() async {
    final salesOrderBox = store.box<SalesOrderModel>();
    final salesOrderCustomerBox = store.box<SalesOrderCustomerModel>();
    final salesOrderPaymentBox = store.box<SalesOrderPaymentModel>();
    final salesOrderProductBox = store.box<OrderProductModel>();
    final contactInfoBox = store.box<ContactInfoModel>();
    final moneyBox = store.box<MoneyModel>();
    final phoneBox = store.box<PhoneModel>();

    store.runInTransaction(TxMode.write, () {
      final allOrders = salesOrderBox.getAll();
      for (final model in allOrders) {
        model.deleteRecursively(
          salesOrderBox,
          salesOrderCustomerBox,
          salesOrderPaymentBox,
          salesOrderProductBox,
          contactInfoBox,
          moneyBox,
          phoneBox
        );
      }
    });
  }

  @override
  Future<int> count() {
    final orderBox = store.box<SalesOrderModel>();
    return Future.value(orderBox.count());
  }
}
import 'dart:async';
import 'package:sales_app/objectbox.g.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/data/models/cnpj_model.dart';
import 'package:sales_app/src/features/customer/data/models/contact_info_model.dart';
import 'package:sales_app/src/features/customer/data/models/cpf_model.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/order_customer_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/order_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/order_product_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/order_repository.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order.dart' as domain;
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/order_status.dart';

class OrderRepositoryImpl extends OrderRepository {
  final Store store;

  OrderRepositoryImpl(this.store);

  @override
  Future<List<domain.Order>> fetchAll(OrderFilter filter) async {
    final box = store.box<OrderModel>();

    Condition<OrderModel>? cond;

    // Texto
    final raw = filter.q?.trim();
    if (raw != null && raw.isNotEmpty) {
      cond =
        OrderModel_.customerName.contains(raw, caseSensitive: false) |
        OrderModel_.orderCode.contains(raw, caseSensitive: false)
      ;
    }

    // Status (ajuste conforme o tipo persistido)
    if (filter.status != null) {
      final statusCond = OrderModel_.status.equals(filter.status!.index);
      cond = (cond == null) ? statusCond : (cond & statusCond);
    }

    final qb = (cond == null) ? box.query() : box.query(cond);

    // Ordenação opcional (ex.: mais recentes primeiro)
    // qb.order(OrderModel_.createdAt, flags: OrderModel_.createdAt.descending);

    final q = qb.build();
    try {
      final models = await q.findAsync();
      return models.map((m) => m.toEntity()).toList();
    } finally {
      q.close();
    }
  }

  @override
  Future<domain.Order> fetchById(int orderId) async {
    try {
      final orderBox = store.box<OrderModel>();

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
  Future<void> saveAll(List<domain.Order> orders) async {
    final orderBox = store.box<OrderModel>();
    final orderCustomerBox = store.box<OrderCustomerModel>();
    final orderProductBox = store.box<OrderProductModel>();
    final contactInfoBox = store.box<ContactInfoModel>();
    final cnpjBox = store.box<CNPJModel>();
    final cpfBox = store.box<CPFModel>();
    final moneyBox = store.box<MoneyModel>();

    store.runInTransaction(TxMode.write, () {
      for (final order in orders) {
        final existingQ = orderBox.query(OrderModel_.orderUuId.equals(order.orderUuId)).build();
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

            final cnpj = customer.cnpj.target;
            if (cnpj != null) {
              cnpjBox.remove(cnpj.id);
            }

            final cpf = customer.cpf.target;
            if (cpf != null) {
              cpfBox.remove(cpf.id);
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
  Future<domain.Order> save(domain.Order order) async {
    final orderBox = store.box<OrderModel>();
    final orderCustomerBox = store.box<OrderCustomerModel>();
    final orderProductBox = store.box<OrderProductModel>();
    final contactInfoBox = store.box<ContactInfoModel>();
    final cnpjBox = store.box<CNPJModel>();
    final cpfBox = store.box<CPFModel>();
    final moneyBox = store.box<MoneyModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existingQ = orderBox.query(OrderModel_.orderUuId.equals(order.orderUuId)).build();
      final existing  = existingQ.findFirst();
      existingQ.close();

      final newModel = order.maybeMap(
        raw: (r) => r.toModel(),
        orElse: () =>
        throw AppException(
          AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
          "Dados do Pedido inválidos para atualização",
        ),
      );

      if (existing != null) {
        newModel.id = existing.id;

        final total = existing.total.target;
        if (total != null) {
          moneyBox.remove(total.id);
        }

        final freight = existing.freight.target;
        if (freight != null) {
          moneyBox.remove(freight.id);
        }

        final customer = existing.customer.target;
        if (customer != null) {

          for (final items in customer.contactInfo) {
            contactInfoBox.remove(items.id);
          }

          final cnpj = customer.cnpj.target;
          if (cnpj != null) {
            cnpjBox.remove(cnpj.id);
          }

          final cpf = customer.cpf.target;
          if (cpf != null) {
            cpfBox.remove(cpf.id);
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

      } else {
        newModel.id = 0;
      }

      // Importante: put() cuidará de persistir ToOne/ToMany que você setou em newModel
      return orderBox.put(newModel);
    });

    final saved = await orderBox.getAsync(id);
    if (saved == null) {
      throw AppException(
        AppExceptionCode.CODE_000_ERROR_UNEXPECTED,
        "Pedido não encontrado após sua inserção",
      );
    }
    return saved.toEntity();
  }

  @override
  Future<void> delete(domain.Order order) async {
    final orderBox = store.box<OrderModel>();
    final orderCustomerBox = store.box<OrderCustomerModel>();
    final orderProductBox = store.box<OrderProductModel>();
    final contactInfoBox = store.box<ContactInfoModel>();
    final cnpjBox = store.box<CNPJModel>();
    final cpfBox = store.box<CPFModel>();
    final moneyBox = store.box<MoneyModel>();

    store.runInTransaction(TxMode.write, () async {
      final model = await orderBox.getAsync(order.orderId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Pedido não encontrado");
      }


      final total = model.total.target;
      if (total != null) {
        moneyBox.remove(total.id);
      }

      final freight = model.freight.target;
      if (freight != null) {
        moneyBox.remove(freight.id);
      }

      final customer = model.customer.target;
      if (customer != null) {

        for (final items in customer.contactInfo) {
          contactInfoBox.remove(items.id);
        }

        final cnpj = customer.cnpj.target;
        if (cnpj != null) {
          cnpjBox.remove(cnpj.id);
        }

        final cpf = customer.cpf.target;
        if (cpf != null) {
          cpfBox.remove(cpf.id);
        }

        orderCustomerBox.remove(model.customer.targetId);
      }

      for (final items in model.items) {

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

      await orderBox.removeAsync(model.id);
    });
  }

  @override
  Future<void> deleteAll() async {
    final orderBox = store.box<OrderModel>();
    final orderCustomerBox = store.box<OrderCustomerModel>();
    final orderProductBox = store.box<OrderProductModel>();
    final contactInfoBox = store.box<ContactInfoModel>();
    final cnpjBox = store.box<CNPJModel>();
    final cpfBox = store.box<CPFModel>();
    final moneyBox = store.box<MoneyModel>();

    store.runInTransaction(TxMode.write, () {
      final allOrders = orderBox.getAll();
      for (final model in allOrders) {

        final total = model.total.target;
        if (total != null) {
          moneyBox.remove(total.id);
        }

        final freight = model.freight.target;
        if (freight != null) {
          moneyBox.remove(freight.id);
        }

        final customer = model.customer.target;
        if (customer != null) {

          for (final items in customer.contactInfo) {
            contactInfoBox.remove(items.id);
          }

          final cnpj = customer.cnpj.target;
          if (cnpj != null) {
            cnpjBox.remove(cnpj.id);
          }

          final cpf = customer.cpf.target;
          if (cpf != null) {
            cpfBox.remove(cpf.id);
          }

          orderCustomerBox.remove(model.customer.targetId);
        }

        for (final items in model.items) {

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
      }
      orderBox.removeAll();
    });
  }

  @override
  Future<int> count() {
    final orderBox = store.box<OrderModel>();
    return Future.value(orderBox.count());
  }
}
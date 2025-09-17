import 'dart:async';
import 'package:sales_app/objectbox.g.dart' hide Order;
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/order/data/models/order_model.dart';
import 'package:sales_app/src/features/order/domain/repositories/order_repository.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';

class OrderRepositoryImpl extends OrderRepository {
  final Store store;

  OrderRepositoryImpl(this.store);

  @override
  Future<List<Order>> fetchAll({String? search}) async {
    final box = store.box<OrderModel>();

    final raw = (search ?? '').trim();
    if (raw.isEmpty) {
      final all = await box.getAllAsync();
      return all.map((m) => m.toEntity()).toList();
    }

    final term = raw.toLowerCase();
    final digits = raw.replaceAll(RegExp(r'\D+'), '');

    final customerNameCond = OrderModel_.customerName.contains(term, caseSensitive: false);
    final customerNameQuery = box.query(customerNameCond).build();
    final byCustomerName = await customerNameQuery.findAsync();
    customerNameQuery.close();

    final seen = <int>{};
    final merged = <OrderModel>[];
    for (final m in [...byCustomerName]) {
      if (seen.add(m.id)) merged.add(m);
    }

    return merged.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Order> fetchById(int orderId) async {
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
  Future<void> saveAll(List<Order> orders) async {
    final orderBox = store.box<OrderModel>();

    store.runInTransaction(TxMode.write, () {
      for (final order in orders) {
        final existing = orderBox.get(order.orderId);

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
        } else {
          newModel.id = 0;
        }

        orderBox.put(newModel);
      }
    });
  }

  @override
  Future<Order> save(Order order) async {
    final orderBox = store.box<OrderModel>();

    final id = store.runInTransaction(TxMode.write, () {
      final existing = orderBox.get(order.orderId);

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
  Future<void> delete(Order order) async {
    final orderBox = store.box<OrderModel>();

    store.runInTransaction(TxMode.write, () async {
      final model = await orderBox.getAsync(order.orderId);

      if (model == null) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Pedido não encontrado");
      }

      await orderBox.removeAsync(model.id);
    });
  }

  @override
  Future<void> deleteAll() async {
    final orderBox = store.box<OrderModel>();

    store.runInTransaction(TxMode.write, () {
      orderBox.removeAll();
    });
  }

  @override
  Future<int> count() {
    final orderBox = store.box<OrderModel>();
    return Future.value(orderBox.count());
  }
}
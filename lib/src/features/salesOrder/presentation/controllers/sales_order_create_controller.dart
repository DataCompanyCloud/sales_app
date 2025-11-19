import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_customer.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/sales_order_status.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';
import 'package:uuid/uuid.dart';

class SalesOrderCreateController extends AutoDisposeFamilyAsyncNotifier<SalesOrder?, int?>{

  @override
  FutureOr<SalesOrder?> build(int? orderId) async {
    if (orderId == null) return null;

    final service = await ref.watch(salesOrderServiceProvider.future);
    final repository = await ref.watch(salesOrderRepositoryProvider.future);

    try {
      final remote = await service.getById(orderId);
      await repository.save(remote);

    } catch (e) {
      print(e);
    }

    return await repository.fetchById(orderId);
  }

  /// 1) Refresh "global" — força a tela voltar pra loading
  Future<void> refresh() async {
    final orderId = arg; // em Riverpod 2.x, `arg` é o parâmetro da family
    if (orderId == null) return;

    state = const AsyncLoading(); // aqui SIM queremos loading global

    final service = await ref.read(salesOrderServiceProvider.future);
    final repository = await ref.read(salesOrderRepositoryProvider.future);

    try {
      final remote = await service.getById(orderId);
      await repository.save(remote);

      final local = await repository.fetchById(orderId);
      state = AsyncData(local);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<SalesOrder> createNewOrder({ Customer? customer }) async {
    try {
      final repository = await ref.read(salesOrderRepositoryProvider.future);

      SalesOrderCustomer? salesOrderCustomer;

      if (customer != null) {
        salesOrderCustomer = SalesOrderCustomer.fromCustomer(customer);
      }

      final newOrder = SalesOrder(
        orderId: 0,
        orderUuId: const Uuid().v4(),
        orderCode: null,
        createdAt: DateTime.now(),
        itemsCount: 0,
        customer: salesOrderCustomer,
        total: Money.zero(),
        items: [],
        orderPaymentMethods: []
      );

      return await repository.save(newOrder);
    } catch (e, st) {
      rethrow;
    }
  }


  /// 2) Salvar/editar em background, sem loading global
  Future<void> saveEdits(SalesOrder updated) async {
    final service = await ref.read(salesOrderServiceProvider.future);
    final repository = await ref.read(salesOrderRepositoryProvider.future);

    // optimistically: atualiza estado local imediatamente
    state = AsyncData(updated);

    try {
      // final remote = await service.(updated);
      final saved = await repository.save(updated);

      state = AsyncData(saved);
    } catch (e, st) {
      // aqui você decide:
      // - manter o último data (não mexer no state)
      // - ou marcar como erro mas mantendo o value anterior
      state = AsyncError(e, st);
      // ou: state = AsyncData(state.value); // se quiser manter silencioso
    }
  }
}


SalesOrderCustomer fakerOrderCustomer () {
  return SalesOrderCustomer(
      customerId: random.integer(1000, min: 1),
      customerCode: random.integer(1000, min: 1).toString().padLeft(2, "00000"),
      customerUuId: const Uuid().v4(),
      customerName: "${faker.company.name()} ${faker.company.name()}",
      contactInfo: null,
      address: null
  );
}


SalesOrderProduct fakerOrderProduct (int index, Money unitPrice) {
  return SalesOrderProduct(
      productId: index,
      productUuId: const Uuid().v4(),
      productCode: index.toString().padLeft(2, "00000"),
      name: "${faker.animal.name()} ${faker.food.cuisine()}",
      quantity: random.integer(10, min: 1).toDouble(),
      unitPrice: unitPrice
  );
}

SalesOrder fakerOrder (int index) {
  Money total = Money.zero();

  final items = List.generate(random.integer(5, min: 0), (index) {
    final money = Money(amount: random.integer(50, min: 1));
    total = total.plus(money);
    return fakerOrderProduct(index, money);
  });

  return SalesOrder(
      orderId: index,
      orderUuId: const Uuid().v4(),
      orderCode: random.boolean() ? random.integer(1000, min: 10).toString().padLeft(2, "00000"): null,
      createdAt: DateTime.now(),
      status: SalesOrderStatus.draft,
      itemsCount: items.length,
      customer: random.boolean() ? null: fakerOrderCustomer(),
      total: total,
      items: items,
      orderPaymentMethods: []
  );
}

List<SalesOrder> fakerOrders () {
  final orders = List.generate(random.integer(5, min: 0), (index) => fakerOrder(index));
  return orders;
}
import 'dart:async';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';
import 'package:sales_app/src/features/product/providers.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_company_group.dart';
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

  Future<SalesOrder> createNewOrder({ Customer? customer, List<SalesOrderProduct>? items }) async {
    try {
      final repository = await ref.read(salesOrderRepositoryProvider.future);

      SalesOrderCustomer? salesOrderCustomer;

      if (customer != null) {
        salesOrderCustomer = SalesOrderCustomer.fromCustomer(customer);
      }

      // final products = items ?? [];

      final productRepository = await ref.read(productRepositoryProvider.future);
      final products = await productRepository.fetchAll(ProductFilter());

      // sorteia um número entre 1 e products.length
      final count = random.integer(products.length - 1);

      // embaralha uma cópia da lista e pega só `count` itens
      final select = [...products]..shuffle();
      final randomProducts = select.take(count).toList();

      final List<SalesOrderCompanyGroup> groups = [];
      final Map<int, int> map = {};
      var i = 0;
      for(var product in randomProducts) {
        if (!map.containsKey(product.companyGroupId)) {
          groups.add(
            SalesOrderCompanyGroup(
              companyId: product.companyGroupId,
              items: [
                SalesOrderProduct(
                  productId: product.productId,
                  productUuId: const Uuid().v4(),
                  productCode: product.code,
                  productName: product.name,
                  quantity: random.integer(10, min: 1).toDouble(),
                  unitPrice: product.price,
                  fiscal: product.fiscal
                )
              ],
              context: null)
          );
          map[product.companyGroupId] = i;
          i++;
          continue;
        }

        groups[map[product.companyGroupId]!].addItem(
          SalesOrderProduct(
            productId: product.productId,
            productUuId: const Uuid().v4(),
            productCode: product.code,
            productName: product.name,
            quantity: random.integer(10, min: 1).toDouble(),
            unitPrice: product.price,
            fiscal: product.fiscal
          )
        );
      }



      final newOrder = SalesOrder(
        orderId: 0,
        orderUuId: const Uuid().v4(),
        orderCode: null,
        createdAt: DateTime.now(),
        itemsCount: randomProducts.length,
        customer: salesOrderCustomer,
        total: Money.zero(),
        companyGroup: groups,
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
    productName: "${faker.animal.name()} ${faker.food.cuisine()}",
    quantity: random.integer(10, min: 1).toDouble(),
    unitPrice: unitPrice,
    fiscal: null
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
      // items: items,
      orderPaymentMethods: [], companyGroup: []
  );
}

List<SalesOrder> fakerOrders () {
  final orders = List.generate(random.integer(5, min: 0), (index) => fakerOrder(index));
  return orders;
}
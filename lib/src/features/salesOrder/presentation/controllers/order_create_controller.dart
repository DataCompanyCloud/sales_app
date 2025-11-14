import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order_customer.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order_product.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/order_repository.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/order_status.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';


OrderCustomer fakerOrderCustomer () {
  return OrderCustomer(
    customerId: random.integer(1000, min: 1),
    customerCode: random.integer(1000, min: 1).toString().padLeft(2, "00000"),
    customerUuId: const Uuid().v4(),
    customerName: "${faker.company.name()} ${faker.company.name()}",
    contactInfo: [ ]
  );
}


OrderProduct fakerOrderProduct (int index, Money unitPrice) {
  return OrderProduct(
    productId: index,
    productUuId: const Uuid().v4(),
    productCode: index.toString().padLeft(2, "00000"),
    name: "${faker.animal.name()} ${faker.food.cuisine()}",
    quantity: random.integer(10, min: 1).toDouble(),
    unitPrice: unitPrice
  );
}

Order fakerOrder (int index) {
  Money total = Money.zero();

  final items = List.generate(random.integer(5, min: 0), (index) {
    final money = Money(amount: random.integer(50, min: 1));
    total = total.plus(money);
    return fakerOrderProduct(index, money);
  });

  return Order(
    orderId: index,
    orderUuId: const Uuid().v4(),
    orderCode: index.toString().padLeft(2, "00000"),
    createdAt: DateTime.now(),
    status: OrderStatus.draft,
    itemsCount: items.length,
    customer: random.boolean() ? null: fakerOrderCustomer(),
    total: total,
    items: items,
    orderPayment: []
  );
}

List<Order> fakerOrders () {
  final orders = List.generate(random.integer(5, min: 0), (index) => fakerOrder(index));
  return orders;
}


class OrderCreateController  extends AutoDisposeAsyncNotifier<List<Order>>{

  @override
  FutureOr<List<Order>> build() async {
    final repository = await ref.read(orderRepositoryProvider.future);
    state = AsyncLoading();

    try {
      // final service = await ref.watch(orderServiceProvider.future);
      // final newOrders = await service.getAll(filter: filter);
      //
      // if (newOrders.isNotEmpty) {
      //   await repository.saveAll(newOrders);
      // }
    } catch (e) {
      print(e);
    }

    return await repository.fetchAll(OrderFilter(
      start: 0,
      limit: 50,
      status: OrderStatus.draft
    ));
  }


  Future<Order> createNewOrder() async {
    try {
      final repository = await ref.read(orderRepositoryProvider.future);

      int id = random.integer(2000, min: 1001);
      final newOrder = Order(
          orderId: 0,
          orderUuId: const Uuid().v4(),
          orderCode: id.toString().padLeft(2, "00000"),
          createdAt: DateTime.now(),
          itemsCount: 0,
          total: Money.zero(),
          items: [],
          orderPayment: []
      );

      return await repository.save(newOrder);
    } catch (e, st) {
      rethrow;
    }
  }
}
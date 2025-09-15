import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const Order._();

  const factory Order.raw ({
    required int orderId,
    required String orderCode,
    required List<Product> products,
    required double totalValue,
    required Map<String, int> quantity,
    required DateTime orderDate,
    required String status
  }) = _Order;

  factory Order ({
    required int orderId,
    required String orderCode,
    required List<Product> products,
    required double totalValue,
    required Map<String, int> quantity,
    required DateTime orderDate,
    required String status
  }) {
    return Order.raw(
      orderId: orderId,
      orderCode: orderCode,
      products: products,
      totalValue: totalValue,
      quantity: quantity,
      orderDate: orderDate,
      status: status
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) =>
      _$OrderFromJson(json);
}
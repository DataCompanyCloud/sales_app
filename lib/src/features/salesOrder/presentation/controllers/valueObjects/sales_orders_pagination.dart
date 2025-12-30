import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';

part 'sales_orders_pagination.freezed.dart';
part 'sales_orders_pagination.g.dart';

@freezed
abstract class SalesOrdersPagination with _$SalesOrdersPagination {
  const SalesOrdersPagination._();

  const factory SalesOrdersPagination({
    @Default([]) List<SalesOrder> items,
    @Default(false) bool isLoadingMore,
    @Default(0) int total,
    String? errorMessage
  }) = _SalesOrdersPagination;

  factory SalesOrdersPagination.fromJson(Map<String, dynamic> json) =>
      _$SalesOrdersPaginationFromJson(json);

  bool get hasMore => items.length < total;
}
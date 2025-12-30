import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';

part 'customers_pagination.freezed.dart';
part 'customers_pagination.g.dart';

@freezed
abstract class CustomersPagination with _$CustomersPagination {
  const CustomersPagination._();

  const factory CustomersPagination({
    @Default([]) List<Customer> items,
    @Default(false) bool isLoadingMore,
    @Default(0) int total,
    String? errorMessage
  }) = _CustomersPagination;

  factory CustomersPagination.fromJson(Map<String, dynamic> json) =>
      _$CustomersPaginationFromJson(json);

  bool get hasMore => items.length < total;
}
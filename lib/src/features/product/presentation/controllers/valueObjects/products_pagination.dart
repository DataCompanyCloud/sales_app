import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

part 'products_pagination.freezed.dart';
part 'products_pagination.g.dart';

@freezed
abstract class ProductsPagination with _$ProductsPagination {
  const ProductsPagination._();

  const factory ProductsPagination({
    @Default([]) List<Product> items,
    @Default(false) bool isLoadingMore,
    @Default(0) int total,
    String? errorMessage
  }) = _ProductsPagination;

  factory ProductsPagination.fromJson(Map<String, dynamic> json) =>
      _$ProductsPaginationFromJson(json);

  bool get hasMore => items.length < total;
}
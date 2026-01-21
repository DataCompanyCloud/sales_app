import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';

part 'storage_products_pagination.freezed.dart';
part 'storage_products_pagination.g.dart';

@freezed
abstract class StorageProductsPagination with _$StorageProductsPagination {
  const StorageProductsPagination._();

  const factory StorageProductsPagination({
    @Default([]) List<StorageProduct> items,
    @Default(false) bool isLoadingMore,
    @Default(0) int total,
    String? errorMessage
  }) = _StorageProductsPagination;

  factory StorageProductsPagination.fromJson(Map<String, dynamic> json) =>
      _$StorageProductsPaginationFromJson(json);

  bool get hasMore => items.length < total;
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';

part 'storages_pagination.freezed.dart';
part 'storages_pagination.g.dart';

@freezed
abstract class StoragesPagination with _$StoragesPagination {
  const StoragesPagination._();

  const factory StoragesPagination({
    @Default([]) List<Storage> items,
    @Default(false) bool isLoadingMore,
    @Default(0) int total,
    String? errorMessage
  }) = _StoragesPagination;

  factory StoragesPagination.fromJson(Map<String, dynamic> json) =>
      _$StoragesPaginationFromJson(json);

  bool get hasMore => items.length < total;
}
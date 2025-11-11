import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/owner_transaction.dart';

part 'storage_endpoint.freezed.dart';
part 'storage_endpoint.g.dart';

@freezed
abstract class StorageEndpoint with _$StorageEndpoint {
  const StorageEndpoint._();

  const factory StorageEndpoint.raw({
    required int storageId,
    required String storageCode,
    required String storageName,
    required String ownerName
  }) = _StorageEndpoint;

  factory StorageEndpoint ({
    required int storageId,
    required String storageCode,
    required String storageName,
    required String ownerName
  }) {

    return StorageEndpoint.raw(
      storageId: storageId,
      ownerName: ownerName,
      storageCode: storageCode,
      storageName: storageName
    );
  }

  factory StorageEndpoint.fromJson(Map<String, dynamic> json) =>
      _$StorageEndpointFromJson(json);
}
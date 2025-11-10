// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:sales_app/src/features/stockTransaction/domain/entities/owner_transaction.dart';
//
// part 'storage_endpoint.freezed.dart';
// part 'storage_endpoint.g.dart';
//
// @freezed
// abstract class StorageEndpoint with _$StorageEndpoint {
//   const StorageEndpoint._();
//
//   const factory StorageEndpoint.raw({
//     required int id,
//     required String code,
//     required OwnerTransaction ownerTransaction,
//     int? fromStorageId,
//     int? toStorageId,
//   }) = _StorageEndpoint;
//
//   factory StorageEndpoint ({
//     required int id,
//     required String code,
//     required OwnerTransaction ownerTransaction,
//     int? fromStorageId,
//     int? toStorageId,
//   }) {
//
//     return StorageEndpoint.raw(
//       id: id,
//       code: code,
//       ownerTransaction: ownerTransaction,
//       fromStorageId: fromStorageId,
//       toStorageId: toStorageId
//     );
//   }
//
//   factory StorageEndpoint.fromJson(Map<String, dynamic> json) =>
//       _$StorageEndpointFromJson(json);
// }
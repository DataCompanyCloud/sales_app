import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_transaction.freezed.dart';
part 'owner_transaction.g.dart';

@freezed
abstract class OwnerTransaction with _$OwnerTransaction {
  const OwnerTransaction._();

  const factory OwnerTransaction.raw({
    required int userId,
    required String userCode,
    required String userName,
  }) = _OwnerTransaction;

  factory OwnerTransaction ({
    required int userId,
    required String userCode,
    required String userName,
  }) {

    return OwnerTransaction(
      userId: userId,
      userCode: userCode,
      userName: userName
    );
  }

  factory OwnerTransaction.fromJson(Map<String, dynamic> json) =>
      _$OwnerTransactionFromJson(json);
}
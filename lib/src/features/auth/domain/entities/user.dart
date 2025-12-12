import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int userId,
    required String userCode,
    required String userName,
    required String token,
    required String? productWalletCode,
    @JsonKey(includeFromJson: false) @Default(false) bool isValidated,
    @Default(null) String? userPassword,
    @Default(false) bool isSync
    // List<Permission> permissons
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
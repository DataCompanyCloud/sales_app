import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/auth/domain/entities/company.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int userId,
    required String userCode,
    required String userName,
    required String token,
    @Default([]) List<Company> company,
    // List<Permission> permissons
    @Default(false) bool rememberMe,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}


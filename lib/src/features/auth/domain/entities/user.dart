import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/company/domain/entities/company.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String code,
    required String firstName,
    required String lastName,
    required String email,
    required DateTime createdAt,
    required String token,
    required String refreshToken,
    required List<Company> companies,
    required Company activeCompany,
    // required List<Role> roles,
    // required List<Permission> permissions,

    // Variáveis locais
    @Default(false) bool isValidated,
    @Default(null) String? password,
    @Default(false) bool isSync
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
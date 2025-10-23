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
    @JsonKey(includeFromJson: false ) @Default(false) bool isValidated,
    @JsonKey(includeFromJson: false ) @Default(null) String? userPassword,
    @Default([]) List<Company> company
    // List<Permission> permissons
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
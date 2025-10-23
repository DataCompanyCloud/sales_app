import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'password.freezed.dart';
part 'password.g.dart';

@freezed
abstract class Password with _$Password {
  const factory Password({
    String? plain,
    required String encrypted,
  }) = _Password;

  factory Password.fromPlain(String plainText) {
    final encrypted = _encrypt(plainText);
    return Password(plain: plainText, encrypted: encrypted);
  }

  factory Password.fromJson(Map<String, dynamic> json) =>
      _$PasswordFromJson(json);
}

String _encrypt(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
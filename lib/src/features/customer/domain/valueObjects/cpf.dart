import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';

part 'cpf.freezed.dart';
part 'cpf.g.dart';

@freezed
abstract class CPF with _$CPF {
  const CPF._();

  const factory CPF.raw({
    required String value
  }) = _CPF;

  factory CPF ({
    required String value
  }) {
    if (value.trim().isEmpty) {
      throw AppException.errorUnexpected("CPF não pode ser nulo.");
    }

    final numericOnly = value.replaceAll(RegExp(r'\D'), '');
    if (numericOnly.length != 11) {
      throw AppException.errorUnexpected("CPF inválido: precisa ter 11 dígitos.");
    }

    return CPF.raw(value: value);
  }

  factory CPF.fromJson(Map<String, dynamic> json) => _$CPFFromJson(json);

  String get formatted {
    final digits = value.padLeft(11, '0');
    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}';
  }
}

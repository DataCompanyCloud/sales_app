import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';

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
      throw AppException(AppExceptionCode.CODE_036_CPF_REQUIRED, 'CPF é obrigatório.');
    }

    final numericOnly = value.replaceAll(RegExp(r'\D'), '');
    if (numericOnly.length != 11) {
      throw AppException(AppExceptionCode.CODE_037_CPF_INVALID_LENGTH, "CPF inválido: precisa ter 11 dígitos.");
    }

    if (!isValidCPF(numericOnly)) {
      throw AppException(AppExceptionCode.CODE_038_CPF_INVALID, 'CPF inválido.');
    }

    return CPF.raw(value: numericOnly);
  }

  factory CPF.fromString(String json) => CPF(value: json);

  factory CPF.fromJson(Map<String, dynamic> json) => _$CPFFromJson(json);


  String get formatted {
    final numericOnly = value.replaceAll(RegExp(r'\D'), '');
    final digits = numericOnly.padLeft(11, '0');
    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}';
  }

  static bool isValidCPF(String cpf) {
    final numbers = cpf.replaceAll(RegExp(r'\D'), '');

    if (numbers.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) return false;

    List<int> digits = numbers.split('').map(int.parse).toList();

    int calcDigit(int length) {
      int sum = 0;
      int weight = length + 1;

      for (int i = 0; i < length; i++) {
        sum += digits[i] * weight--;
      }

      int mod = sum % 11;
      return mod < 2 ? 0 : 11 - mod;
    }

    return calcDigit(9) == digits[9] &&
        calcDigit(10) == digits[10];
  }
}


class CPFConverter extends JsonConverter<CPF, String> {
  const CPFConverter();

  @override
  CPF fromJson(String json) => CPF.fromString(json);

  @override
  String toJson(CPF object) => object.value;
}


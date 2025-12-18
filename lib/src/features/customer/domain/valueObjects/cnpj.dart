import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';

part 'cnpj.freezed.dart';
part 'cnpj.g.dart';

@freezed
abstract class CNPJ with _$CNPJ {
  const CNPJ._();

  const factory CNPJ.raw({
    required String value
  }) = _CNPJ;

  factory CNPJ ({
    required String value
  }) {

    if (value.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_039_CNPJ_REQUIRED, 'CNPJ é obrigatório.');
    }

    final numericOnly = value.replaceAll(RegExp(r'\D'), '');
    if (numericOnly.length != 14) {
      throw AppException(AppExceptionCode.CODE_040_CNPJ_INVALID_LENGTH, "CNPJ inválido: precisa ter 14 dígitos.");
    }

    if (!isValidCNPJ(numericOnly)) {
      throw AppException(AppExceptionCode.CODE_041_CNPJ_INVALID, 'CNPJ inválido.');
    }


    return CNPJ.raw(value: numericOnly);
  }

  /// Usado se você quiser criar a partir de uma string simples,
  /// ex: CNPJ.fromString("12.345.678/0001-90")
  factory CNPJ.fromString(String json) => CNPJ(value: json);

  /// Continua existindo para quando você quiser o formato:
  /// { "value": "..." }
  factory CNPJ.fromJson(Map<String, dynamic> json) => _$CNPJFromJson(json);


  String get formatted {
    final numericOnly = value.replaceAll(RegExp(r'\D'), '');
    final digits = numericOnly.padLeft(14, '0');

    return '${digits.substring(0, 2)}.'
        '${digits.substring(2, 5)}.'
        '${digits.substring(5, 8)}/'
        '${digits.substring(8, 12)}-'
        '${digits.substring(12, 14)}';
  }

  static bool isValidCNPJ(String cnpj) {
    final numbers = cnpj.replaceAll(RegExp(r'\D'), '');

    if (numbers.length != 14) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) return false;

    final digits = numbers.split('').map(int.parse).toList();

    const weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    const weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    int calc(List<int> weights, int length) {
      int sum = 0;
      for (int i = 0; i < length; i++) {
        sum += digits[i] * weights[i];
      }
      int mod = sum % 11;
      return mod < 2 ? 0 : 11 - mod;
    }

    return calc(weights1, 12) == digits[12] &&
        calc(weights2, 13) == digits[13];
  }
}



class CnpjConverter extends JsonConverter<CNPJ, String> {
  const CnpjConverter();

  @override
  CNPJ fromJson(String json) => CNPJ.fromString(json);
  // ou direto: CNPJ(value: json);

  @override
  String toJson(CNPJ object) => object.value;
}



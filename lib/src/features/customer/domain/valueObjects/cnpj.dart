import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';

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
      throw AppException.errorUnexpected("CNPJ não pode ser nulo.");
    }

    final numericOnly = value.replaceAll(RegExp(r'\D'), '');
    if (numericOnly.length != 14) {
      throw AppException.errorUnexpected("CNPJ inválido: precisa ter 14 dígitos.");
    }

    return CNPJ.raw(value: value);
  }

  /// Usado se você quiser criar a partir de uma string simples,
  /// ex: CNPJ.fromString("12.345.678/0001-90")
  factory CNPJ.fromString(String json) => CNPJ(value: json);

  /// Continua existindo para quando você quiser o formato:
  /// { "value": "..." }
  factory CNPJ.fromJson(Map<String, dynamic> json) => _$CNPJFromJson(json);


  String get formatted {
    final digits = value.padLeft(14, '0');
    return '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12, 14)}';
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

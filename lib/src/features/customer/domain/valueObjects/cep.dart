import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';

part 'cep.freezed.dart';
part 'cep.g.dart';

@freezed
abstract class CEP with _$CEP {
  const CEP._(); // permite métodos/fábricas custom

  /// criar sem validação
  const factory CEP.raw({
    required String value
  }) = _CEP;

  /// cria com validações
  factory CEP ({
    required String value
  }){
    if (value.trim().isEmpty) {
      throw AppException.errorUnexpected("CEP não pode ser nulo.");
    }

    final numericOnly = value.replaceAll(RegExp(r'\D'), '');
    if (numericOnly.length != 8) {
      throw AppException.errorUnexpected('CEP inválido: precisa ter 8 dígitos.');
    }

    return CEP.raw(value: value);
  }

  factory CEP.fromJson(Map<String, dynamic> json) => _$CEPFromJson(json);
}

//
// class CEP {
//   final String value;
//
//   CEP(String? cep) : value = _cleanAndValidate(cep ?? '') {
//     if (cep == null) {
//       throw ArgumentError('CEP não pode ser nulo.');
//     }
//   }
//
//   static String _cleanAndValidate(String? cep) {
//     // desformata
//     final numericOnly = cep?.replaceAll(RegExp(r'\D'), '') ?? '';
//
//     if (numericOnly.length != 8) {
//       throw ArgumentError('CEP inválido.');
//     }
//
//     return numericOnly;
//   }
//
//   String get formatted {
//     final digits = value.padLeft(8, '0');
//     return '${digits.substring(0, 5)}-${digits.substring(5, 8)}';
//   }
//
//   @override
//   String toString() => formatted;
// }


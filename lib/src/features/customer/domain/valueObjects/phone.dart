import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';

part 'phone.freezed.dart';
part 'phone.g.dart';

enum PhoneType {
  mobile,
  landline,
  whatsapp,
  other
}
@freezed
abstract class Phone with _$Phone {
  const Phone._();

  const factory Phone.raw({
    required String value,
    required PhoneType type,
  }) = _Phone;

  factory Phone ({
    required String value,
    required PhoneType type
  }) {
    if (value.trim().isEmpty) {
      throw AppException.errorUnexpected("Telefone não pode ser nulo.");
    }

    final phoneRegex = value.replaceAll(RegExp(r'^(\(\d{3}\)\s?\d{3}-\d{4}|\d{3}-\d{3}-\d{4}|\d{3}\.\d{3}\.\d{4}|\d{10})$'), '');
    if (phoneRegex != value) {
      AppException.errorUnexpected("Telefone inváido: precisa ser um telefone válido.");
    }

    return Phone.raw(value: value, type: type);
  }

  factory Phone.fromJson(Map<String, dynamic> json) => _$PhoneFromJson(json);
}

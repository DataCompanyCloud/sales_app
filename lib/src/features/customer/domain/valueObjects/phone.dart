import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';

part 'phone.freezed.dart';
part 'phone.g.dart';

@freezed
abstract class Phone with _$Phone {
  const Phone._();

  const factory Phone.raw({
    required String value
  }) = _Phone;

  factory Phone ({
    required String value
  }) {
    if (value.trim().isEmpty) {
      throw AppException.errorUnexpected("Telefone não pode ser nulo.");
    }

    final phoneRegex = value.replaceAll(RegExp(r'^(\(\d{3}\)\s?\d{3}-\d{4}|\d{3}-\d{3}-\d{4}|\d{3}\.\d{3}\.\d{4}|\d{10})$'), '');
    if (phoneRegex != value) {
      AppException.errorUnexpected("Telefone inváido: precisa ser um telefone válido.");
    }

    return Phone.raw(value: value);
  }

  factory Phone.fromJson(Map<String, dynamic> json) => _$PhoneFromJson(json);
}

/*
class Phone {
  final String value;

  Phone({
    required this.value
  }) {

    if (value.trim().isEmpty) {
      throw ArgumentError('Phone: "number" cannot be empty.');
    }

    final phoneRegex = RegExp(r'^(\(\d{3}\)\s?\d{3}-\d{4}|\d{3}-\d{3}-\d{4}|\d{3}\.\d{3}\.\d{4}|\d{10})$');
    if (!phoneRegex.hasMatch(value)) {
      throw ArgumentError('Phone: "number" must be a valid phone number.');
    }
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Phone && runtimeType == other.runtimeType && value == other.value;

  // verifica se os números de telefone são repetidos
  @override
  int get hashCode => value.hashCode;
}
*/
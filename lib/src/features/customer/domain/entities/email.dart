import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';

part 'email.freezed.dart';
part 'email.g.dart';

@freezed
abstract class Email with _$Email {
  const Email._();

  const factory Email.raw({
    required String value
  }) = _Email;

  factory Email ({
    required String value
  }) {
    if (value.trim().isEmpty) {
      throw AppException.errorUnexpected("Email não pode ser nulo.");
    }

    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
        r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
        r"(?:\.[a-zA-Z]{2,})+$"
    );
    if (!emailRegex.hasMatch(value)) {
      throw AppException.errorUnexpected("Email inválido: preisa ser um email válido.");
    }

    return Email.raw(value: value);
  }

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
}

/*
class Email {
  final String value;

  Email({
    required this.value
  }) {

    if (value.trim().isEmpty) {
      throw ArgumentError('Email: "value" cannot be empty.');
    }

    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
        r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
        r"(?:\.[a-zA-Z]{2,})+$"
    );
    if (!emailRegex.hasMatch(value)) {
      throw ArgumentError('Email: "value" must be a valid email.');
    }
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Email && runtimeType == other.runtimeType && value == other.value;

  // verifica se os emails são repetidos
  @override
  int get hashCode => value.hashCode;
}
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';

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
      throw AppException(AppExceptionCode.CODE_029_EMAIL_REQUIRED, "E-mail é obrigatório.");
    }

    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
        r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
        r"(?:\.[a-zA-Z]{2,})+$"
    );
    if (!emailRegex.hasMatch(value)) {
      throw AppException(AppExceptionCode.CODE_028_EMAIL_INVALID, "E-mail informado é inválido.");
    }

    return Email.raw(value: value);
  }

  factory Email.fromString(String json) => Email(value: json);

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
}


class EmailConverter extends JsonConverter<Email, String> {
  const EmailConverter();

  @override
  Email fromJson(String json) => Email.fromString(json);

  @override
  String toJson(Email object) => object.value;
}

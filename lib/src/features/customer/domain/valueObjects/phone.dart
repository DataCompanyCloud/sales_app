import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/country_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone_type.dart';

part 'phone.freezed.dart';
part 'phone.g.dart';

@freezed
abstract class Phone with _$Phone {
  const Phone._();

  const factory Phone.raw({
    required String value, // sempre E.164
    required PhoneType type,
    @Default(CountryCode.BR) CountryCode countryCode,
  }) = _Phone;

  factory Phone({
    required String value,
    required PhoneType type,
    CountryCode countryCode = CountryCode.BR,
  }) {
    final normalized = _normalizeToE164(
      input: value,
      countryCode: countryCode,
    );

    _validatePhone(normalized, countryCode);

    return Phone.raw(
      value: normalized,
      type: type,
      countryCode: countryCode,
    );
  }

  factory Phone.fromJson(Map<String, dynamic> json) =>
      _$PhoneFromJson(json);

  String get formattedNational {
    switch (countryCode) {
      case CountryCode.BR:
        final national = _nationalNumber;
        final ddd = national.substring(0, 2);
        final number = national.substring(2);

        if (number.length == 9) {
          return '($ddd) ${number.substring(0, 5)}-${number.substring(5)}';
        }
        return '($ddd) ${number.substring(0, 4)}-${number.substring(4)}';
    }
  }

  String get formattedInternational => '${countryCode.e164Prefix} $formattedNational';

  String get _nationalNumber => value.replaceFirst(countryCode.e164Prefix, '');
}

String _normalizeToE164({
  required String input,
  required CountryCode countryCode,
}) {
  var digits = input.replaceAll(RegExp(r'\D'), '');

  if (digits.startsWith('00')) {
    digits = digits.substring(2);
  }

  if (!digits.startsWith(countryCode.dialingCode)) {
    digits = countryCode.dialingCode + digits;
  }

  return '+$digits';
}

void _validatePhone(String e164, CountryCode countryCode) {
  // if (!e164.startsWith(countryCode.e164Prefix)) {
  //   throw AppException( AppExceptionCode.CODE_022_PHONE_INVALID_LENGTH, 'Telefone inválido para o país ${countryCode.isoCode}.',);
  // }

  final national = e164.replaceFirst(countryCode.e164Prefix, '');
  final length = national.length;

  if (length < countryCode.minLength ||
      length > countryCode.maxLength) {
    throw AppException(
      AppExceptionCode.CODE_022_PHONE_INVALID_LENGTH,
      'Telefone inválido. Quantidade de dígitos incorreta.',
    );
  }

  switch (countryCode) {
    case CountryCode.BR:
      final ddd = int.tryParse(national.substring(0, 2));
      if (ddd == null || ddd < 11 || ddd > 99) {
        throw AppException(AppExceptionCode.CODE_023_PHONE_INVALID_DDD, 'Telefone inválido. DDD incorreto.');
      }

      final number = national.substring(2);

      if (number.length == 9 && !number.startsWith('9')) {
        throw AppException(AppExceptionCode.CODE_024_PHONE_INVALID_NUMBER, 'Telefone inválido.');
      }
      break;
  }
}

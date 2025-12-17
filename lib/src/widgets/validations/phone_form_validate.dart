import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/country_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone_type.dart';

part 'phone_form_validate.freezed.dart';

@freezed
abstract class PhoneFormValidate with _$PhoneFormValidate {
  const PhoneFormValidate._();

  const factory PhoneFormValidate({
    String? phoneError,
    String? countryCodeError,
    String? formError,
  }) = _PhoneFormValidate;

  bool get hasError =>
    phoneError != null ||
    formError != null ||
    countryCodeError != null
  ;

  PhoneFormValidate clearErrors() => copyWith(
    phoneError: null,
    formError: null,
    countryCodeError: null
  );
}

class PhoneFormNotifier extends StateNotifier<PhoneFormValidate> {
  PhoneFormNotifier() : super(const PhoneFormValidate());

  /// Valida o CEP e retorna um Value Object válido
  Phone? validate({
    required String value,
    required PhoneType type,
    required CountryCode countryCode,
  }) {
    try {
      return Phone(
        value: value,
        type: type,
        countryCode: countryCode
      );
    } on AppException catch (e) {
      state = state.clearErrors();

      switch (e.code) {
        case AppExceptionCode.CODE_022_PHONE_INVALID_LENGTH:
        case AppExceptionCode.CODE_023_PHONE_INVALID_DDD:
        case AppExceptionCode.CODE_024_PHONE_INVALID_NUMBER:
          state = state.copyWith(phoneError: e.message);
          break;

        default:
          state = state.copyWith(formError: e.message);
      }
    } catch (_) {
      state = state.copyWith(formError: 'Erro inesperado ao validar telefone');
    }

    return null;
  }

  void setError({String? formError, String? phoneError, String? countryCodeError}) {
    state = state.copyWith(formError: formError, phoneError: phoneError, countryCodeError: countryCodeError);
  }

  bool get hasError => state.hasError;
}

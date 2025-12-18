import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';

part 'cnpj_form_validate.freezed.dart';

@freezed
abstract class CnpjFormValidate with _$CnpjFormValidate {
  const CnpjFormValidate._();

  const factory CnpjFormValidate({
    String? cnpjError,
    String? formError,
  }) = _CnpjFormValidate;

  bool get hasError => cnpjError != null || formError != null;

  CnpjFormValidate clearErrors() => copyWith(
      cnpjError: null,
      formError: null
  );
}



class CnpjFormNotifier extends StateNotifier<CnpjFormValidate> {
  CnpjFormNotifier() : super(const CnpjFormValidate());

  CNPJ? validate(String value) {
    try {
      state = state.clearErrors();

      return CNPJ(value: value);
    } on AppException catch (e) {
      state = state.clearErrors();

      switch (e.code) {
        case AppExceptionCode.CODE_039_CNPJ_REQUIRED:
        case AppExceptionCode.CODE_040_CNPJ_INVALID_LENGTH:
        case AppExceptionCode.CODE_041_CNPJ_INVALID:
          state = state.copyWith(cnpjError: e.message);
          break;

        default:
          state = state.copyWith(formError: e.message);
      }
    } catch (_) {
      state = state.copyWith(formError: 'Erro inesperado ao validar CPF');
    }

    return null;
  }

  void setError({String? formError, String? cnpjError}) {
    state = state.copyWith(formError: formError, cnpjError: cnpjError);
  }

  bool get hasError => state.hasError;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cep_form_validate.freezed.dart';

@freezed
abstract class CepFormValidate with _$CepFormValidate {
  const CepFormValidate._();

  const factory CepFormValidate({
    String? cepError,
    String? formError,
  }) = _CepFormValidate;

  bool get hasError => cepError != null || formError != null;

  CepFormValidate clearErrors() => copyWith(
    cepError: null,
    formError: null
  );
}



class CepFormNotifier extends StateNotifier<CepFormValidate> {
  CepFormNotifier() : super(const CepFormValidate());

  /// Valida o CEP e retorna um Value Object válido
  CEP? validate(String value) {
    try {
      return CEP(value: value);
    } on AppException catch (e) {
      state = state.clearErrors();

      switch (e.code) {
        case AppExceptionCode.CODE_020_CEP_REQUIRED:
        case AppExceptionCode.CODE_021_CEP_INVALID_LENGTH:
          state = state.copyWith(cepError: e.message);
          break;

        default:
          state = state.copyWith(formError: e.message);
      }
    } catch (_) {
      state = state.copyWith(formError: 'Erro inesperado ao validar CEP');
    }

    return null;
  }

  void setError({String? formError, String? cepError}) {
    state = state.copyWith(formError: formError, cepError: cepError);
  }

  bool get hasError => state.hasError;
}

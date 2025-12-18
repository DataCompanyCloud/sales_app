import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';

part 'cpf_form_validate.freezed.dart';

@freezed
abstract class CpfFormValidate with _$CpfFormValidate {
  const CpfFormValidate._();

  const factory CpfFormValidate({
    String? cpfError,
    String? formError,
  }) = _CpfFormValidate;

  bool get hasError => cpfError != null || formError != null;

  CpfFormValidate clearErrors() => copyWith(
      cpfError: null,
      formError: null
  );
}



class CpfFormNotifier extends StateNotifier<CpfFormValidate> {
  CpfFormNotifier() : super(const CpfFormValidate());

  /// Valida o CEP e retorna um Value Object válido
  CPF? validate(String value) {
    try {
      state = state.clearErrors();

      return CPF(value: value);
    } on AppException catch (e) {
      state = state.clearErrors();

      switch (e.code) {
        case AppExceptionCode.CODE_036_CPF_REQUIRED:
        case AppExceptionCode.CODE_037_CPF_INVALID_LENGTH:
        case AppExceptionCode.CODE_038_CPF_INVALID:
          state = state.copyWith(cpfError: e.message);
          break;

        default:
          state = state.copyWith(formError: e.message);
      }
    } catch (_) {
      state = state.copyWith(formError: 'Erro inesperado ao validar CPF');
    }

    return null;
  }

  void setError({String? formError, String? cpfError}) {
    state = state.copyWith(formError: formError, cpfError: cpfError);
  }

  bool get hasError => state.hasError;
}

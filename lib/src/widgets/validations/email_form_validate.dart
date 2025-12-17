import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';

part 'email_form_validate.freezed.dart';

@freezed
abstract class EmailFormValidate with _$EmailFormValidate {
  const EmailFormValidate._();

  const factory EmailFormValidate({
    String? emailError,
    String? formError,
  }) = _EmailFormValidate;

  bool get hasError => emailError != null || formError != null;

  EmailFormValidate clearErrors() => copyWith(
    emailError: null,
    formError: null
  );
}



class EmailFormNotifier extends StateNotifier<EmailFormValidate> {
  EmailFormNotifier() : super(const EmailFormValidate());

  /// Valida o CEP e retorna um Value Object válido
  Email? validate(String value) {
    try {
      return Email(value: value);
    } on AppException catch (e) {
      state = state.clearErrors();

      switch (e.code) {
        case AppExceptionCode.CODE_028_EMAIL_INVALID:
        case AppExceptionCode.CODE_029_EMAIL_REQUIRED:
          state = state.copyWith(emailError: e.message);
          break;

        default:
          state = state.copyWith(formError: e.message);
      }
    } catch (_) {
      state = state.copyWith(formError: 'Erro inesperado ao validar email');
    }

    return null;
  }

  void setError({String? formError, String? cepError}) {
    state = state.copyWith(formError: formError, emailError: cepError);
  }

  bool get hasError => state.hasError;
}

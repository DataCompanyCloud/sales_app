import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';

part 'contact_info_form_validate.freezed.dart';

@freezed
abstract class ContactInfoFormValidate with _$ContactInfoFormValidate {
  const ContactInfoFormValidate._(); // permite métodos/fábricas custom

  const factory ContactInfoFormValidate({
    String? formError,
    String? nameError,
    String? emailError,
    String? phoneError,
  }) = _ContactInfoFormValidate;

  bool get hasError =>
      formError != null ||
      nameError != null ||
      emailError != null ||
      phoneError != null;

  /// Limpa todos os erros do formulário
  ContactInfoFormValidate clearErrors() => copyWith(
    formError: null,
    nameError: null,
    emailError: null,
    phoneError: null,
  );
}

/// Notifier responsável por validar os dados do formulário de endereço.
///
/// Ele atua como a ponte entre:
/// - o domínio (entidade Contato, que lança AppException)
/// - e a UI (que consome os erros por campo via state)
///
/// Nenhuma regra de validação fica na UI.
class ContactInfoFormNotifier extends StateNotifier<ContactInfoFormValidate> {
  ContactInfoFormNotifier() : super(const ContactInfoFormValidate());

  /// Valida os dados do formulário e tenta construir um Contato válido.
  ///
  /// Fluxo:
  /// 1. Tenta criar o Contato (validação de domínio)
  /// 2. Se sucesso → retorna Contato
  /// 3. Se falha → captura AppException e mapeia erro para o campo correto
  ///
  /// Retorna:
  /// - Contato válido → quando não há erros
  /// - null → quando há erro de validação
  ContactInfo? validate({
    required String name,
    required Email? email,
    required Phone? phone,
    required bool isPrimary
  }) {
    try {
      return ContactInfo(
        name: name,
        email: email,
        phone: phone,
        isPrimary: isPrimary
      );
    } on AppException catch (e) {
      state = state.clearErrors();

      switch (e.code) {
        case AppExceptionCode.CODE_025_CONTACT_NAME_REQUIRED:
          state = state.copyWith(nameError: e.message);
          break;

        case AppExceptionCode.CODE_027_NAME_INVALID:
          state = state.copyWith(nameError: e.message);
          break;

        case AppExceptionCode.CODE_026_CONTACT_EMPTY:
          state = state.copyWith(emailError: e.message, phoneError: e.message);
          break;

        default:
          state = state.copyWith(formError: e.message);
      }
    } catch (_) {
      state = state.copyWith(formError: 'Erro inesperado ao validar contato');
    }

    return null;
  }

  void setError({
    String? formError,
    String? nameError,
    String? emailError,
    String? phoneError,
  }) {
    state = state.copyWith(
      formError: formError,
      nameError: nameError,
      emailError: emailError,
      phoneError: phoneError,
    );
  }


  bool get hasError => state.hasError;
}

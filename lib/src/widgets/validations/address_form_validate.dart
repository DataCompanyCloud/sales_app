import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address_type.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';

part 'address_form_validate.freezed.dart';

@freezed
abstract class AddressFormValidate with _$AddressFormValidate {
  const AddressFormValidate._(); // permite métodos/fábricas custom

  const factory AddressFormValidate({
    String? formError,
    String? districtError,
    String? streetError,
    String? numberError,
    String? cityError,
    String? stateError,
    String? typeError
  }) = _AddressFormValidate;

  bool get hasError =>
    formError != null ||
    districtError != null ||
    streetError != null ||
    numberError != null ||
    cityError != null ||
    stateError != null ||
    typeError != null
  ;

  /// Limpa todos os erros do formulário
  AddressFormValidate clearErrors() => copyWith(
    formError: null,
    districtError: null,
    streetError: null,
    numberError: null,
    cityError: null,
    stateError: null,
    typeError: null,
  );
}

/// Notifier responsável por validar os dados do formulário de endereço.
///
/// Ele atua como a ponte entre:
/// - o domínio (entidade Address, que lança AppException)
/// - e a UI (que consome os erros por campo via state)
///
/// Nenhuma regra de validação fica na UI.
class AddressFormNotifier extends StateNotifier<AddressFormValidate> {
  AddressFormNotifier() : super(const AddressFormValidate());

  /// Valida os dados do formulário e tenta construir um Address válido.
  ///
  /// Fluxo:
  /// 1. Tenta criar o Address (validação de domínio)
  /// 2. Se sucesso → retorna Address
  /// 3. Se falha → captura AppException e mapeia erro para o campo correto
  ///
  /// Retorna:
  /// - Address válido → quando não há erros
  /// - null → quando há erro de validação
  Address? validate({
    required BrazilianState? state_,
    required String city,
    required String district,
    required String street,
    required AddressType type,
    required bool isPrimary,
    int? number,
    CEP? cep
  }) {
    try {

      if (state_ == null) {
        throw AppException(AppExceptionCode.CODE_016_STATE_REQUIRED, "UF é obrigatório" );
      }

      return Address(
        cep: cep,
        number: number,
        state: state_,
        city: city,
        street: street,
        district: district,
        type: type,
        isPrimary: isPrimary
      );
    } on AppException catch (e) {
      state = state.clearErrors();

      switch (e.code) {
        case AppExceptionCode.CODE_015_CITY_REQUIRED: state = state.copyWith(cityError: e.message);
          break;
        case AppExceptionCode.CODE_017_STREET_REQUIRED: state = state.copyWith(streetError: e.message);
          break;
        case AppExceptionCode.CODE_018_DISTRICT_REQUIRED: state = state.copyWith(districtError: e.message);
          break;
        case AppExceptionCode.CODE_016_STATE_REQUIRED: state = state.copyWith(stateError: e.message);
          break;
        case AppExceptionCode.CODE_019_TYPE_REQUIRED: state = state.copyWith(typeError: e.message);
          break;
        default: state = state.copyWith(formError: e.message);
      }
    } catch (_) {
      state = state.copyWith(
        formError: 'Erro inesperado ao validar endereço',
      );
    }

    return null;
  }

  bool get hasError => state.hasError;
}

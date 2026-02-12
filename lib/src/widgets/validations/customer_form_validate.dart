import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/credit_limit.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/state_registration.dart';

part 'customer_form_validate.freezed.dart';

@freezed
abstract class CustomerFormValidate with _$CustomerFormValidate {
  const CustomerFormValidate._();

  const factory CustomerFormValidate({
    String? formError,
    String? fullNameError,
    String? legalNameError,
    String? tradeNameError,
    String? paymentMethodsError,
    String? contactsError,
    String? cpfError,
    String? cnpjError,
    String? addressesError,
  }) = _CustomerFormValidate;

  bool get hasError =>
    formError != null ||
    fullNameError != null ||
    legalNameError != null ||
    tradeNameError != null ||
    paymentMethodsError != null ||
    contactsError != null ||
    cpfError != null ||
    cnpjError != null ||
    addressesError != null
  ;

  CustomerFormValidate clearErrors() => copyWith(
    formError: null,
    fullNameError: null,
    legalNameError: null,
    tradeNameError: null,
    paymentMethodsError: null,
    contactsError: null,
    cpfError: null,
    cnpjError: null,
    addressesError: null,
  );
}



class CustomerFormNotifier extends StateNotifier<CustomerFormValidate> {
  CustomerFormNotifier() : super(const CustomerFormValidate());
  
  Customer? validate({
    required bool isPerson,
    required int id,             // ObjectBox ID
    required String uuid,        // gerado no app
    String? businessSector,
    String? code,
    String? fullName,
    String? legalName,
    String? tradeName,
    StateRegistration? stateRegistration,
    CreditLimit? creditLimit,
    TaxRegime? taxRegime,
    required List<PaymentMethod> paymentMethods,
    required List<ContactInfo> contacts,
    CPF? cpf,
    CNPJ? cnpj,
    required List<Address> addresses,
    required bool isActive,
    String? notes
  }) {
    try {
      state = state.clearErrors();

      return Customer(
        id: id,
        uuid: uuid,
        code: code,
        externalId: '',
        businessSector: businessSector,
        fullName: fullName,
        legalName: legalName,
        tradeName: tradeName,
        stateRegistration: stateRegistration,
        creditLimit: creditLimit,
        taxRegime: taxRegime,
        paymentMethods: paymentMethods,
        contacts: contacts,
        cpf: cpf,
        cnpj: cnpj,
        addresses: addresses,
        isActive: isActive,
        notes: notes,
      );
    } on AppException catch (e) {
      state = state.clearErrors();

      switch (e.code) {
        case AppExceptionCode.CODE_030_DOCUMENT_REQUIRED:
          state = isPerson
            ? state.copyWith(cpfError: "CPF é obrigatório")
            : state.copyWith(cnpjError: "CNPJ é obrigatório");
          break;

        case AppExceptionCode.CODE_031_DOCUMENT_CONFLICT:
          state = state.copyWith(cnpjError: e.message, cpfError: e.message);
          break;

        case AppExceptionCode.CODE_032_PERSON_NAME_REQUIRED:
          state = state.copyWith(fullNameError: e.message);
          break;

        case AppExceptionCode.CODE_033_CUSTOMER_ADDRESS_REQUIRED:
          state = state.copyWith(addressesError: e.message);
          break;

        case AppExceptionCode.CODE_034_CUSTOMER_CONTACT_REQUIRED:
          state = state.copyWith(contactsError: e.message);
          break;

        case AppExceptionCode.CODE_035_CUSTOMER_PAYMENT_METHOD_REQUIRED:
          state = state.copyWith(paymentMethodsError: e.message);
          break;

        default:
          state = state.copyWith(formError: e.message);
      }
    } catch (_) {
      state = state.copyWith(formError: 'Erro inesperado ao validar Cliente');
    }

    return null;
  }

  void setError({
    String? formError,
    String? fullNameError,
    String? legalNameError,
    String? tradeNameError,
    String? paymentMethodsError,
    String? contactsError,
    String? cpfError,
    String? cnpjError,
    String? addressesError,
  }) {
    state = state.copyWith(
      formError: formError,
      fullNameError: fullNameError,
      legalNameError: legalNameError,
      tradeNameError: tradeNameError,
      paymentMethodsError: paymentMethodsError,
      contactsError: contactsError,
      cpfError: cpfError,
      cnpjError: cnpjError,
      addressesError: addressesError,
    );
  }

  bool get hasError => state.hasError;
}

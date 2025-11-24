import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/credit_limit.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/state_registration.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
abstract class Customer with _$Customer {
  const Customer._();

  const factory Customer.person({
    required int customerId,             // ObjectBox ID
    required String customerUuId,        // gerado no app
    int? serverId,                       // vindo do server
    required String? customerCode,
    required String? fullName,
    CreditLimit? creditLimit,
    TaxRegime? taxRegime,
    @Default([]) List<PaymentMethod> paymentMethods,
    @Default([]) List<ContactInfo> contacts,
    CPF? cpf,
    @Default([]) List<Address> addresses,
    required bool isActive,
    String? notes
  }) = PersonCustomer;

  const factory Customer.company({
    required int customerId,             // ObjectBox ID
    required String customerUuId,        // gerado no app
    int? serverId,                       // vindo do server
    int? businessGroupId,
    String? businessSector,
    required String? customerCode,
    required String? legalName,
    required String? tradeName,
    required StateRegistration stateRegistration,
    CreditLimit? creditLimit,
    TaxRegime? taxRegime,
    @Default([]) List<PaymentMethod> paymentMethods,
    @Default([]) List<ContactInfo> contacts,
    CNPJ? cnpj,
    @Default([]) List<Address> addresses,
    required bool isActive,
    String? notes
  }) = CompanyCustomer;

  /// TODO Precisa fazer as validações somente quando as informações forem diferentes de null!
  factory Customer({
    required int customerId,             // ObjectBox ID
    required String customerUuId,        // gerado no app
    int? serverId,                       // vindo do server
    int? businessGroupId,
    String? businessSector,
    required String? customerCode,
    required String? fullName,
    required String? legalName,
    required String? tradeName,
    StateRegistration? stateRegistration,
    CreditLimit? creditLimit,
    TaxRegime? taxRegime,
    List<PaymentMethod> paymentMethods = const [],
    List<ContactInfo> contacts = const [],
    CPF? cpf,
    CNPJ? cnpj,
    required List<Address> addresses,
    required bool isActive,
    String? notes
  }) {
    // validações comuns

    final hasCpf = cpf != null;
    final hasCnpj = cnpj != null;

    // precisa ter exatamente um: CPF ou CNPJ
    if (!hasCpf && !hasCnpj) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Informe um CPF ou um CNPJ");
    }

    if (hasCpf && hasCnpj) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Informe apenas CPF ou apenas CNPJ, não ambos");
    }

    // se for pessoa física
    if (hasCpf) {
      if (fullName == null || fullName.trim().isEmpty) {
        throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Para pessoa física, o nome completo é obrigatório");
      }

      return Customer.person(
        customerId: customerId,
        customerUuId: customerUuId,
        serverId: serverId,
        customerCode: customerCode,
        fullName: fullName,
        paymentMethods: paymentMethods,
        contacts: contacts,
        creditLimit: creditLimit,
        taxRegime: taxRegime,
        cpf: cpf,
        addresses: addresses,
        isActive: isActive,
        notes: notes,
      );
    }

    // se caiu aqui, é pessoa jurídica (tem CNPJ)
    if (legalName == null || legalName.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Para pessoa jurídica, a razão social é obrigatória");
    }

    if (tradeName == null || tradeName.trim().isEmpty) {
      throw AppException( AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Para pessoa jurídica, o nome fantasia é obrigatório");
    }

    if (stateRegistration == null) {
      throw AppException( AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "Para pessoa jurídica, a inscrição estadual é obrigatória");
    }

    return Customer.company(
      customerId: customerId,
      customerUuId: customerUuId,
      serverId: serverId,
      businessGroupId: businessGroupId,
      businessSector: businessSector,
      customerCode: customerCode,
      legalName: legalName,
      tradeName: tradeName,
      stateRegistration: stateRegistration,
      paymentMethods: paymentMethods,
      contacts: contacts,
      creditLimit: creditLimit,
      taxRegime: taxRegime,
      cnpj: cnpj,
      addresses: addresses,
      isActive: isActive,
      notes: notes,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  bool get hasCreditLimit => creditLimit != null && creditLimit!.available.amount > 0;

  ContactInfo? get primaryContact {
    if (contacts.isEmpty) return null;
    return contacts.firstWhere(
      (c) => c.isPrimary,
      orElse: () => contacts.first,
    );
  }


  Address? get primaryAddress {
    if (addresses.isEmpty) return null;

    return addresses.firstWhere(
      (a) => a.isPrimary,
      orElse: () => addresses.first
    );
  }
}


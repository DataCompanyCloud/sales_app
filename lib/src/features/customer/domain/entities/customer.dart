import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/credit_limit.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/payment_method.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/state_registration.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/tax_regime.dart';

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
    Address? address,
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
    Address? address,
    required bool isActive,
    String? notes
  }) = CompanyCustomer;

  const factory Customer.raw({
    required int customerId,             // ObjectBox ID
    required String customerUuId,        // gerado no app
    int? serverId,                       // vindo do server
    int? businessGroupId,
    String? businessSector,
    required String? customerCode,
    required String? fullName,
    required String? legalName,
    required String? tradeName,
    required StateRegistration stateRegistration,
    CreditLimit? creditLimit,
    TaxRegime? taxRegime,
    @Default([]) List<PaymentMethod> paymentMethods,
    @Default([]) List<ContactInfo> contacts,
    CPF? cpf,
    CNPJ? cnpj,
    Address? address,
    required bool isActive,
    String? notes
  }) = RawCustomer;

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
    required StateRegistration stateRegistration,
    CreditLimit? creditLimit,
    TaxRegime? taxRegime,
    List<PaymentMethod> paymentMethods = const [],
    List<ContactInfo> contacts = const [],
    CPF? cpf,
    CNPJ? cnpj,
    Address? address,
    required bool isActive,
    String? notes
  }) {
    // Validações
    if (contacts.isEmpty) {
      throw AppException.errorUnexpected('O Cliente precisa ter pelo menos um contado informado');
    }

    return Customer.raw(
      customerId: customerId,
      customerUuId: customerUuId,
      serverId: serverId,
      businessGroupId: businessGroupId,
      businessSector: businessSector,
      customerCode: customerCode,
      fullName: fullName,
      legalName: legalName,
      tradeName: tradeName,
      stateRegistration: stateRegistration,
      paymentMethods: paymentMethods,
      contacts: contacts,
      creditLimit: creditLimit,
      taxRegime: taxRegime,
      cpf: cpf,
      cnpj: cnpj,
      address: address,
      isActive: isActive,
      notes: notes
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  bool get hasCreditLimit => creditLimit != null && creditLimit!.available.amount > 0;

  ContactInfo? get primaryContact {
    if (contacts.isEmpty) return null;
    return contacts.firstWhere(
      (c) => c.isPrimary,
      orElse: () => contacts.first,
    );
  }
}


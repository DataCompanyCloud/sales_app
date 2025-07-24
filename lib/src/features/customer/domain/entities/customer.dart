import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/entities/address.dart';
import 'package:sales_app/src/features/customer/domain/entities/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/entities/cpf.dart';
import 'package:sales_app/src/features/customer/domain/entities/email.dart';
import 'package:sales_app/src/features/customer/domain/entities/phone.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
abstract class Customer with _$Customer {
  const Customer._();

  const factory Customer.person({
    required int customerId,
    required String? customerCode,
    required String? fullName,
    CPF? cpf,
    Email? email,
    List<Phone>? phones,
    Address? address,
    required bool isActive,
    required bool isSynced
  }) = PersonCustomer;

  const factory Customer.company({
    required int customerId,
    required String? customerCode,
    required String? legalName,
    required String? tradeName,
    CNPJ? cnpj,
    Email? email,
    List<Phone>? phones,
    Address? address,
    required bool isActive,
    required bool isSynced
  }) = CompanyCustomer;

  const factory Customer.raw({
    required int customerId,
    required String? customerCode,
    required String? fullName,
    required String? legalName,
    required String? tradeName,
    CPF? cpf,
    CNPJ? cnpj,
    Email? email,
    List<Phone>? phones,
    Address? address,
    required bool isActive,
    required bool isSynced
  }) = RawCustomer;

  /// TODO Precisa fazer as validações somente quando as informações forem diferentes de null!
  factory Customer({
    required int customerId,
    required String? customerCode,
    required String? fullName,
    required String? legalName,
    required String? tradeName,
    CPF? cpf,
    CNPJ? cnpj,
    Email? email,
    List<Phone>? phones,
    Address? address,
    required bool isActive,
    required bool isSynced
  }) {

    // if (customerId <= 0) {
    //   throw AppException.errorUnexpected('Customer ID não pode ser negativo ou igual a 0.');
    // }

    // if (customerCode.trim().isEmpty) {
    //   throw AppException.errorUnexpected('Customer vazio');
    // }

    return Customer.raw(customerId: customerId, customerCode: customerCode, fullName: fullName, legalName: legalName, tradeName: tradeName, cpf: cpf, cnpj: cnpj, email: email, phones: phones, address: address, isActive: isActive, isSynced: isSynced);
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}


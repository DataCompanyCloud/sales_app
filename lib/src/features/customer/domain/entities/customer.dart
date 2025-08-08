import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
abstract class Customer with _$Customer {
  const Customer._();

  const factory Customer.person({
    required int customerId,                // ObjectBox ID
    required String customerUuId,           // gerado no app
    int? serverId,                       // vindo do server
    required String? customerCode,
    required String? fullName,
    CPF? cpf,
    Email? email,
    List<Phone>? phones,
    Address? address,
    required bool isActive
  }) = PersonCustomer;

  const factory Customer.company({
    required int customerId,                // ObjectBox ID
    required String customerUuId,             // gerado no app
    int? serverId,                       // vindo do server
    required String? customerCode,
    required String? legalName,
    required String? tradeName,
    CNPJ? cnpj,
    Email? email,
    List<Phone>? phones,
    Address? address,
    required bool isActive,
  }) = CompanyCustomer;

  const factory Customer.raw({
    required int customerId,                // ObjectBox ID
    required String customerUuId,             // gerado no app
    int? serverId,                       // vindo do server
    required String? customerCode,
    required String? fullName,
    required String? legalName,
    required String? tradeName,
    CPF? cpf,
    CNPJ? cnpj,
    Email? email,
    List<Phone>? phones,
    Address? address,
    required bool isActive
  }) = RawCustomer;

  /// TODO Precisa fazer as validações somente quando as informações forem diferentes de null!
  factory Customer({
    required int customerId,                // ObjectBox ID
    required String customerUuId,             // gerado no app
    int? serverId,                       // vindo do server
    required String? customerCode,
    required String? fullName,
    required String? legalName,
    required String? tradeName,
    CPF? cpf,
    CNPJ? cnpj,
    Email? email,
    List<Phone>? phones,
    Address? address,
    required bool isActive
  }) {
    // Validações

    // if (customerId <= 0) {
    //   throw AppException.errorUnexpected('Customer ID não pode ser negativo ou igual a 0.');
    // }

    // if (customerCode.trim().isEmpty) {
    //   throw AppException.errorUnexpected('Customer vazio');
    // }

    return Customer.raw(customerId: customerId, customerUuId: customerUuId, serverId: serverId, customerCode: customerCode, fullName: fullName, legalName: legalName, tradeName: tradeName, cpf: cpf, cnpj: cnpj, email: email, phones: phones, address: address, isActive: isActive);
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}


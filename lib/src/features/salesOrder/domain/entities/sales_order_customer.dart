import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cpf.dart';

part 'sales_order_customer.freezed.dart';
part 'sales_order_customer.g.dart';

@freezed
abstract class SalesOrderCustomer with _$SalesOrderCustomer {
  const SalesOrderCustomer._();

  const factory SalesOrderCustomer.raw({
    required int customerId,
    required String? customerCode,
    required String customerUuId,
    required String customerName,
    required ContactInfo? contactInfo ,
    required Address? address,
    @CPFConverter() CPF? cpf,
    @CnpjConverter() CNPJ? cnpj,
    int? orderId
  }) = _SalesOrderCustomer;

  factory SalesOrderCustomer({
    required int customerId,
    required String? customerCode,
    required String customerUuId,
    required String customerName,
    required ContactInfo? contactInfo,
    required Address? address,
    @CPFConverter() CPF? cpf,
    @CnpjConverter() CNPJ? cnpj,
    int? orderId
  }) {
    //TODO: Fazer as validações

    return SalesOrderCustomer.raw(
      customerId: customerId,
      customerCode: customerCode,
      customerUuId: customerUuId,
      customerName: customerName,
      contactInfo: contactInfo,
      address: address,
      cpf: cpf,
      cnpj: cnpj,
      orderId: orderId
    );
  }

  factory SalesOrderCustomer.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderCustomerFromJson(json);


  static SalesOrderCustomer? fromCustomer(Customer customer) {
    // Melhorar isso
    return customer.maybeMap(
      person: (person) {
        return SalesOrderCustomer(
          customerId: person.id,
          customerCode: person.code,
          customerUuId: person.uuId,
          customerName: person.fullName ?? "--",
          contactInfo: person.primaryContact,
          address: person.primaryAddress,
          cpf: person.cpf
        );
      },
      company: (company) {
        return SalesOrderCustomer(
          customerId: company.id,
          customerCode: company.code,
          customerUuId: company.uuId,
          customerName: company.legalName ?? company.tradeName ?? "--",
          contactInfo: company.primaryContact,
          address: company.primaryAddress,
          cnpj: company.cnpj
        );
      },
      orElse: () => null
    );

  }

  @JsonKey(includeFromJson: false)
  bool get isPerson => cpf != null && cnpj == null;

}
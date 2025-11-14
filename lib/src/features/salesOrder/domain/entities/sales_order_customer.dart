import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
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
    @Default(<ContactInfo>[]) List<ContactInfo> contactInfo,
    CPF? cpf,
    CNPJ? cnpj,
    int? orderId
  }) = _SalesOrderCustomer;

  factory SalesOrderCustomer({
    required int customerId,
    required String? customerCode,
    required String customerUuId,
    required String customerName,
    required List<ContactInfo> contactInfo ,
    CPF? cpf,
    CNPJ? cnpj,
    int? orderId
  }) {
    //TODO: Fazer as validações

    return SalesOrderCustomer.raw(
      customerId: customerId,
      customerCode: customerCode,
      customerUuId: customerUuId,
      customerName: customerName,
      contactInfo: contactInfo,
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
          customerId: person.customerId,
          customerCode: person.customerCode,
          customerUuId: person.customerUuId,
          customerName: person.fullName ?? "--",
          contactInfo: person.contacts
        );
      },
      company: (company) {
        return SalesOrderCustomer(
          customerId: company.customerId,
          customerCode: company.customerCode,
          customerUuId: company.customerUuId,
          customerName: company.legalName ?? company.tradeName ?? "--",
          contactInfo: company.contacts
        );
      },
      orElse: () => null
    );

  }

}
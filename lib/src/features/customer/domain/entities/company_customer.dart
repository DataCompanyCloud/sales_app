import 'package:sales_app/src/features/customer/domain/entities/cnpj.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/entities/email.dart';
import 'package:sales_app/src/features/customer/domain/entities/phone.dart';
import 'package:sales_app/src/features/customer/domain/entities/address.dart' as entity;


class CompanyCustomer extends Customer {
  final String legalName;     // Razão social
  final String tradeName;     // Nome fantasia
  final CNPJ cnpj;


  CompanyCustomer({
    required this.legalName,
    required this.tradeName,
    required this.cnpj,

    required super.customerId,
    required super.email,
    required super.phones,
    required super.address,
    required super.isActive,
    required super.customerCode
  });


  /// Opção para determinar se mostra o nome fantasia ou razão social
  String getDisplayName({bool useTradeName = false}) {
    return useTradeName ? tradeName : legalName;
  }


  CompanyCustomer copyWith({
    String? legalName,
    String? tradeName,
    CNPJ? cnpj,
    Email? email,
    List<Phone>? phones,
    entity.Address? address,
    bool? isActive
  }) {
    return CompanyCustomer(
        customerId: customerId,
        customerCode: customerCode,
        legalName: legalName ?? this.legalName,
        tradeName: tradeName ?? this.tradeName,
        cnpj: cnpj ?? this.cnpj,
        email: email ?? this.email,
        phones: phones ?? this.phones,
        address: address ?? this.address,
        isActive: isActive ?? this.isActive
    );
  }

}
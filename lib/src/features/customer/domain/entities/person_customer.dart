import 'package:sales_app/src/features/customer/domain/entities/cpf.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';

class PersonCustomer extends Customer {
  final String fullName;
  final CPF cpf;

  PersonCustomer({
    required this.fullName,
    required this.cpf,

    required super.customerId,
    required super.email,
    required super.phones,
    required super.address,
    required super.isActive,
    required super.customerCode
  });

}
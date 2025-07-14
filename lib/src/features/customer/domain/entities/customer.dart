import 'package:sales_app/src/features/customer/domain/entities/address.dart';
import 'package:sales_app/src/features/customer/domain/entities/email.dart';
import 'package:sales_app/src/features/customer/domain/entities/phone.dart';

abstract class Customer {
  final int customerId;
  final String customerCode;
  final Email email;
  final List<Phone> phones;
  final Address address;
  final bool isActive;

  Customer({
    required this.customerId,
    required this.customerCode,
    required this.email,
    required this.phones,
    required this.address,
    required this.isActive
  }) {
    if (customerId <= 0) {
      throw ArgumentError('Customer: "id" cannot be negative.');
    }

    if (customerCode.trim() == "") {
      throw ArgumentError('Customer: "code" cannot be empty.');
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/company_customer.dart';
import 'package:sales_app/src/features/customer/domain/entities/person_customer.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_providers.dart';
import 'package:sales_app/src/features/customer/presentation/views/company_customer_details.dart';
import 'package:sales_app/src/features/customer/presentation/views/person_customer_details.dart';


class CustomerDetails extends ConsumerWidget {
  final String title;
  final int customerId;

  const CustomerDetails ({
    super.key,
    required this.title,
    required this.customerId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(customerViewModelProvider);
    final customer = viewModelProvider.getCustomerById(customerId);

    if (customer is CompanyCustomer) {
      return CompanyCustomerDetails(customer: customer);
    }

    if (customer is PersonCustomer) {
      return PersonCustomerDetails(customer: customer);
    }

    return Scaffold();
  }
}
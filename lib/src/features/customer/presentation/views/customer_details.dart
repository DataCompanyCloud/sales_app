import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/screens/company_customer_details.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/screens/person_customer_details.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/skeleton/customer_details_skeleton.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';

class CustomerDetails extends ConsumerWidget {
  final int customerId;

  const CustomerDetails ({
    super.key,
    required this.customerId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(customerDetailsControllerProvider(customerId));

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => CustomerDetailsSkeleton(),
      data: (customer) {
        return customer.maybeMap(
          person: (person) => PersonCustomerDetails(customer: person),
          company: (company) => CompanyCustomerDetails(customer: company),
          orElse: () => Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                  "Não foi possível mostrar os dados do cliente"
              ),
            ),
          ),
        );
      },
    );
  }
}
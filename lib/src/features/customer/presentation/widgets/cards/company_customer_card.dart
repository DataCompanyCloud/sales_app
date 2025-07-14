import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/company_customer.dart';

class CompanyCustomerCard extends ConsumerWidget {
  final CompanyCustomer customer;

  const CompanyCustomerCard ({
    super.key,
    required this.customer
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200, width: 2)
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(AppRoutes.customerDetails.name, extra: customer.customerId);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: customer.isActive ? Colors.green : Colors.red,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                    ),
                    child: Icon(
                        Icons.apartment,
                        color: Colors.white,
                        size: 38
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  customer.legalName
                              ),
                              Text(
                                  customer.cnpj.formatted
                              ),
                              Text(
                                  "${customer.address.city}, ${customer.address.state}"
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.chevron_right, size: 28)
                        ),
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
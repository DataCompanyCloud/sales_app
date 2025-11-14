import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order.dart';

class OrderCreateScreen extends ConsumerStatefulWidget {
  final Order? order;

  const OrderCreateScreen({
    super.key,
    required this.order
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OrderCreateScreenState();
}

class OrderCreateScreenState extends ConsumerState<OrderCreateScreen>{
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final order = widget.order;
    final customer = order?.customer;
    final document = customer?.cnpj ?? customer?.cpf;
    String? selectedValue;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 22, left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: scheme.onTertiary, width: 2)
                  ),
                  child: customer == null
                    ? SizedBox(
                      height: 48,
                        child: Center(
                          child: Text(
                            "Selecionar Cliente",
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                        ),
                      )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: scheme.onPrimary,
                            borderRadius: BorderRadius.circular(40)
                          ),
                          child: Icon(
                            customer.cnpj != null
                              ? Icons.apartment
                              : Icons.person
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.customerName ?? "--"
                              ),
                              Text(
                                customer.customerCode ?? "--",
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                              Text(
                                customer.cnpj?.formatted ?? customer.cpf?.formatted ?? "--",
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.menu,
                        )
                      ],
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
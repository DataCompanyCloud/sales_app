import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_customer.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/indicator/pulsing_dot.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/skeleton/sales_order_create_page_skeleton.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderCreatePage extends ConsumerStatefulWidget {
  final int? orderId;

  const SalesOrderCreatePage({
    super.key,
    required this.orderId,
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SalesOrderCreatePageState();
}

class SalesOrderCreatePageState extends ConsumerState<SalesOrderCreatePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(salesOrderCreateControllerProvider(widget.orderId));

    return controller.when(
      error: (error, stack ) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => SalesOrderCreatePageSkeleton(),
      data: (order) {
        final theme = Theme.of(context);
        final scheme = theme.colorScheme;
        final isConnected = ref.watch(isConnectedProvider);
        final order = controller.value;


        final customer = order?.customer;
        final document = customer?.cnpj ?? customer?.cpf;
        String? selectedValue;

        return  Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: PulsingDot(
                    color:
                    order?.serverId == null
                        ? Colors.red
                        : order?.isPendingSync == true
                        ? Colors.yellow
                        : Colors.blue,
                    animated: isConnected,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                    order?.orderCode ?? "Novo Pedido"
                )
              ],
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  context.pushNamed(OrderRouter.drafts.name);
                },
                icon: Icon(Icons.change_circle_outlined),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              if (controller.isLoading) return;
              final _ = ref.refresh(salesOrderCreateControllerProvider(widget.orderId)); 
            },
            child: SizedBox(
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
                        InkWell(
                          onTap: () async {
                            final selected = await context.pushNamed<Customer?>(OrderRouter.select_customer.name);

                            if (selected == null) return;

                            if (order != null) {
                              final newOrder = order.copyWith(
                                customer: SalesOrderCustomer.fromCustomer(selected),
                                updatedAt: DateTime.now()
                              );

                              await ref
                                  .read(salesOrderCreateControllerProvider(widget.orderId).notifier)
                                  .saveEdits(newOrder);
                              return;
                            }

                            final newOrder = await ref
                              .read(salesOrderCreateControllerProvider(widget.orderId).notifier)
                              .createNewOrder(customer: selected);

                            if (!context.mounted) return;
                            context.goNamed(OrderRouter.create.name, queryParameters: {"orderId": newOrder.orderId.toString()});
                          },
                          child: Container(
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
        );
      },
    );

  }
}
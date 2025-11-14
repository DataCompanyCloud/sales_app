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
import 'package:sales_app/src/features/salesOrder/presentation/widgets/section/customer_section.dart';
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
                    SalesOrderCustomerSection(order: order)
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_model.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/indicator/pulsing_dot.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/section/sales_order_customer_section.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/section/sales_order_finished_section.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/section/sales_order_products_section.dart';
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
                  order?.code ?? "Criar Pedido",
                  textAlign: TextAlign.center,
                )
              ],
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  context.pushNamed(SalesOrderRouter.drafts.name);
                },
                icon: Icon(Icons.change_circle_outlined),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: scheme.outline, // cor da linha
                height: 1.0,                 // espessura da linha
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SalesOrderCustomerSection(order: order),
                      SizedBox(height: 24),
                      SalesOrderProductsSection(order: order),
                    ],
                  ),
                ),
                SizedBox(height: 36),
                Divider(
                  height: 2,
                  thickness: 4,
                  color: scheme.outline,
                ),
              ],
            ),
          ),
          bottomNavigationBar: SalesOrderFinishedSection(order: order),
        );
      },
    );
  }
}
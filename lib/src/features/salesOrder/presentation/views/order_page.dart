import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/order_repository.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/order_status.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/buttons/order_status_buttons.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/order_card.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/skeleton/order_page_skeleton.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class OrderPage extends ConsumerStatefulWidget {

  const OrderPage({
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OrderListPageState();
}

class OrderListPageState extends ConsumerState<OrderPage>{
  final orderIndexProvider = StateProvider<int>((ref) => 1);
  final isSearchOpenProvider = StateProvider<bool>((_) => false);
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final isOpen = ref.read(isSearchOpenProvider.notifier);
    isOpen.state = !isOpen.state;

    if (!isOpen.state) {
      ref.read(orderFilterProvider.notifier).state = OrderFilter();
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(orderIndexProvider);
    final controller = ref.watch(orderControllerProvider);
    final status = ref.watch(orderStatusFilterProvider);
    final isSearchOpen = ref.watch(isSearchOpenProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => Scaffold(
        body: OrderPageSkeleton(),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
      ),
      data: (orders) {
        if (orders.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Lista de Pedidos"),
              leading: IconButton(
                onPressed: () {
                  context.goNamed(HomeRouter.home.name);
                },
                icon: Icon(Icons.arrow_back_ios_new, size: 22),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_rounded,
                      size: 96,
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    Text("Nenhum pedido para ser mostrado."),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    InkWell(
                      onTap: () => ref.refresh(orderControllerProvider.future),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("Tentar novamente", style: TextStyle(color: Colors.blue),),
                      )
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: scheme.onSurface,
            title: Text("Lista de Pedidos"),
            leading: IconButton(
              onPressed: () {
                context.goNamed(HomeRouter.home.name);
              },
              icon: Icon(Icons.arrow_back_ios_new, size: 22),
            ),
            actions: [
              IconButton(
                onPressed: _toggleSearch,
                icon: Icon(isSearchOpen ? Icons.close : Icons.search),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              if (controller.isLoading) return;
              final _ = ref.refresh(orderControllerProvider);
            },
            child: Column(
              children: [
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isSearchOpen
                    ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Pesquisar...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      onSubmitted: (search) {
                        if (search.isEmpty) return;

                        ref.read(orderFilterProvider.notifier).state = OrderFilter(q: search);
                      },
                    ),
                  ) : SizedBox.shrink(),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      int countAll = 0;
                      int countFinished = 0;
                      int countNotFinished = 0;
                      int countCancelled = 0;
                      int countSynced = 0;
                      int countNotSynced = 0;

                      final orderFiltered = orders.where((order) {
                        countAll++;

                        if (order.serverId != null) {
                          countSynced++;
                        } else {
                          countNotSynced++;
                        }

                        if (order.status == OrderStatus.confirmed) {
                          countFinished++;
                        } else if (order.status == OrderStatus.cancelled) {
                          countCancelled++;
                        } else if (order.status == OrderStatus.draft) {
                          countNotFinished++;
                        }

                        if (status == OrderStatusFilter.finished) {
                          return order.status == OrderStatus.confirmed;
                        }

                        if (status == OrderStatusFilter.notFinished) {
                          return order.status == OrderStatus.draft;
                        }

                        if (status == OrderStatusFilter.cancelled) {
                          return order.status == OrderStatus.cancelled;
                        }

                        if (status == OrderStatusFilter.synced) {
                          return order.serverId != null;
                        }

                        if (status == OrderStatusFilter.notSynced) {
                          return order.serverId ==  null;
                        }

                        return true;
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OrderStatusButtons(
                            countAll: countAll,
                            countFinished: countFinished,
                            countNotFinished: countNotFinished,
                            countCancelled: countCancelled,
                            countSynced: countSynced,
                            countNotSynced: countNotSynced,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              itemCount: orderFiltered.length,
                              itemBuilder: (context, index) {
                                final order = orderFiltered[index];

                                return GestureDetector(
                                  onTap: () {
                                    context.pushNamed(OrderRouter.details.name, pathParameters: {"orderId": order.orderId.toString()});
                                  },
                                  child: OrderCard(order: order),
                                );
                              }
                            ),
                          ),
                        ],
                      );
                    }
                  )
                )
              ],
            )
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "btn-go",
                backgroundColor: Color(0xFF0081F5),
                foregroundColor: Colors.white,
                onPressed: () {
                  context.pushNamed(OrderRouter.create.name);
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
        );
      }
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/repositories/customer_repository.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/buttons/customer_status_buttons.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/company_customer_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/person_customer_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/skeleton/customer_page_skeleton.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_screen.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';

class SelectCustomerPage extends ConsumerStatefulWidget {
  final int? customerId;

  const SelectCustomerPage({
    super.key,
    required this.customerId,
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SalesOrderCreatePageState();
}

class SalesOrderCreatePageState extends ConsumerState<SelectCustomerPage> {
  final customerIndexProvider = StateProvider<int>((ref) => 3);
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
      ref.read(customerFilterProvider.notifier).state = CustomerFilter();
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(customerIndexProvider);
    final controller = ref.watch(customerControllerProvider);
    final status = ref.watch(customerStatusFilterProvider);
    final isSearchOpen = ref.watch(isSearchOpenProvider);

    // final theme = Theme.of(context);
    // final scheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorScreen(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => Scaffold(
        body: CustomerPageSkeleton(),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
      ),
      data: (customers) {
        if(customers.isEmpty) {
          return Scaffold(
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
                    Text("Nenhum cliente para ser mostrado."),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    InkWell(
                        onTap: () => ref.refresh(customerControllerProvider.future),
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
            title: Text("Clientes"),
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
              final _ = ref.refresh(customerControllerProvider);
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

                        ref.read(customerFilterProvider.notifier).state = CustomerFilter(q: search);
                      },
                    ),
                  ) : SizedBox.shrink(),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      int countAll       = 0;
                      int countActive    = 0;
                      int countBlocked   = 0;
                      int countSynced    = 0;
                      int countNotSynced = 0;

                      final customerFiltered = customers.where((customer) {
                        // conta no “all”
                        countAll++;

                        // conta ativo vs bloqueado
                        if (customer.isActive) {
                          countActive++;
                        } else {
                          countBlocked++;
                        }

                        // conta sincronizado vs não sincronizado
                        if (customer.serverId != null) {
                          countSynced++;
                        } else {
                          countNotSynced++;
                        }

                        if (status == CustomerStatusFilter.active) {
                          return customer.isActive;
                        }
                        if (status == CustomerStatusFilter.blocked) {
                          return !customer.isActive;
                        }
                        if (status == CustomerStatusFilter.synced) {
                          return customer.serverId != null;
                        }
                        if (status == CustomerStatusFilter.notSynced) {
                          return customer.serverId == null;
                        }
                        // Se for "all", retorna todos
                        return true;
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomerStatusButtons(
                            countAll: countAll,
                            countActive: countActive,
                            countBlocked: countBlocked,
                            countSynced: countSynced,
                            countNotSynced: countNotSynced,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              itemCount: customerFiltered.length,
                              itemBuilder: (context, index) {
                                final customer = customerFiltered[index];
                                return customer.maybeMap(
                                  person: (person) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: GestureDetector(
                                      onTap: () => context.pop<Customer?>(person),
                                      child: PersonCustomerCard(customer: person)
                                    ),
                                  ),
                                  company: (company) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: GestureDetector(
                                      onTap: () => context.pop<Customer?>(company),
                                      child: CompanyCustomerCard(customer: company)
                                    ),
                                  ),
                                  orElse: () => SizedBox()
                                );
                              }
                            )
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/customer_filter.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/buttons/customer_status_buttons.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/company_customer_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/person_customer_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/draggable/draggable_customer_filter.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/skeleton/customer_page_skeleton.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_screen.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';

class CustomerPage extends ConsumerStatefulWidget {
  const CustomerPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CustomerPageState();
}


class CustomerPageState extends ConsumerState<CustomerPage>{
  final isSearchOpenProvider = StateProvider<bool>((_) => false);
  final searchQueryProvider   = StateProvider<String>((_) => '');
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
    // final viewModelProvider = ref.watch(customerViewModelProvider);
    final controller = ref.watch(customerControllerProvider);
    final status = ref.watch(customerStatusFilterProvider);
    final filter = ref.watch(customerFilterProvider);
    final filterActives = filter.activeFiltersCount;
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    final isSearchOpen   = ref.watch(isSearchOpenProvider);
    final searchQuery    = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text("Clientes"),
        leading: IconButton(
          onPressed: () {
            context.goNamed(HomeRouter.home.name);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => DraggableCustomerFilter()
                  );
                },
                icon: filterActives > 0
                  ? Badge.count(
                      count: filterActives,
                      child: Icon(Icons.filter_alt),
                    )
                  : Icon(Icons.filter_alt)
                ,
              ),
              IconButton(
                onPressed: _toggleSearch,
                icon: Icon(isSearchOpen ? Icons.close : Icons.search),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedSize(
            //vsync: vsync,
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
                onChanged: (value) {
                  // atualiza o provider com o texto atual
                  ref.read(searchQueryProvider.notifier).state = value;
                },
                onSubmitted: (query) {
                  ref.read(customerFilterProvider.notifier).state = CustomerFilter(
                    name: _searchController.text
                  );
                },
              ),
            ) : SizedBox.shrink(),
          ),
          Expanded(
            child: controller.when(
              error: (error, stack) => ErrorScreen(
                exception: error is AppException
                    ? error
                    : AppException.errorUnexpected(error.toString()),
              ),
              loading: () =>  CustomerPageSkeleton(),
              data: (customers) {
                if(customers.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_rounded,
                          size: 96,
                        ),
                        Padding(padding: EdgeInsets.only(top: 12)),
                        Text("Nenhum cliente para ser mostrado"),
                        Padding(padding: EdgeInsets.only(top: 16)),
                        InkWell(
                          onTap: () => ref.refresh(customerControllerProvider.future),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Tentar novamente"),
                          )
                        ),
                      ],
                    ),
                  );
                }
            
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
                  if (customer.isSynced) {
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
                    return customer.isSynced;
                  }
                  if (status == CustomerStatusFilter.notSynced) {
                    return !customer.isSynced;
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
                                    child: InkWell(
                                        onTap: () => context.pushNamed(CustomerRouter.customerDetails.name, extra: customer.customerId),
                                        child: PersonCustomerCard(customer: person)
                                    ),
                                  ),
                                  company: (company) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: InkWell(
                                        onTap: () => context.pushNamed(CustomerRouter.customerDetails.name, extra: customer.customerId),
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
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        onPressed: () {
          context.pushNamed(CustomerRouter.createCustomer.name);
        },
        child: Icon(Icons.group_add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
    );

  }
}
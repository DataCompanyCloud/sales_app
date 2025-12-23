import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/company/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';

class DraggableCompanySelector extends ConsumerStatefulWidget {
  const DraggableCompanySelector ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DraggableCompanySelectorState();
}

class DraggableCompanySelectorState extends ConsumerState<DraggableCompanySelector>{

  int? selectedIndex;
  void tapOption(int index) {
    selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(companyGroupControllerProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString())
      ),
      loading: () {
        return CircularProgressIndicator();
      },
      data: (groups) {

        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Padding(
                padding: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: scheme.onPrimaryContainer
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        "Alterar de Empresa",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
          
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Grupo ${group.groupId}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              ...group.companies.map((company) {
                                final isPrimary = group.primaryCompany?.companyId == company.companyId;
          
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    visualDensity: const VisualDensity(vertical: 3),
                                    leading: CircleAvatar(
                                      backgroundColor: scheme.onSecondary,
                                      child: Icon(Icons.factory),
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(company.tradeName),
                                        ),
                                        if (isPrimary)
                                          Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: scheme.inversePrimary,
                                              borderRadius: BorderRadius.circular(12)
                                            ),
                                            child: Text(
                                              "Principal",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      "CNPJ: ${company.cnpj.formatted}",
                                    ),
                                    trailing: Icon(Icons.chevron_right),
                                    onTap: () {
                                      ref.read(companyGroupControllerProvider.notifier)
                                      .setPrimaryCompany(
                                        groupId: group.groupId,
                                        companyId: company.companyId
                                      );
                                      context.pop(company);
                                    },
                                  ),
                                );
                              })
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        );
      }
    );
  }
}

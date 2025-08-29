import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/auth/providers.dart';
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
    final controller = ref.watch(authControllerProvider);
    // final theme = Theme.of(context);
    // final scheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString())
      ),
      loading: () {
        return CircularProgressIndicator();
      },
      data: (user) {
        if (user == null) {
          return Center(
            child: Text("Empresas não encontradas")
          );
        }
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 1.0,
          minChildSize: 0.4,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey[300]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Alterar de Empresa",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: user.company.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndex == index;
                        return ListTile(
                          visualDensity: VisualDensity(vertical: 3),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            child: Icon(Icons.factory, color: Colors.black87),
                          ),
                          title: Text("Empregador: ${user.company[index].tradeName}"),
                          subtitle: Text("CNPJ: ${user.company[index].cnpj.formatted}"),
                          trailing: Icon(
                            isSelected ? Icons.check_circle : Icons.circle_outlined
                          ),
                          onTap: () {
                            tapOption(index);
                            context.pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}
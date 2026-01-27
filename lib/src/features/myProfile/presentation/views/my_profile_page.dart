import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/widgets/badges/text_badge.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';

class MyProfilePage extends ConsumerWidget {

  const MyProfilePage({
    super.key,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final controller = ref.watch(authControllerProvider);

    return controller.when(
      error: (error, stack) {
        return ErrorPage(
          exception: AppException(AppExceptionCode.CODE_014_USER_NOT_FOUND, "Usuário não encontrado.")
        );
      },
      loading: () => CircularProgressIndicator(),
      data: (user) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Meu Perfil"),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back_ios_new, size: 22)
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: scheme.outline,
                height: 1.0,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 52, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: scheme.primaryContainer,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: scheme.surface,
                    child: Icon(Icons.person, size: 52),
                  ),
                ),
              ),
              TextBadge(
                text: user!.isSync ? "Sincronizado" : "Não-Sincronizado",
                color: user.isSync ? Colors.green: Colors.red,
              ),
              const SizedBox(height: 6),
              Text(
                user.firstName,
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      user.code,
                      style: TextStyle(
                        color: scheme.secondary
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Informações Pessoais",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: scheme.outline
                    ),
                    color: scheme.surface
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email),
                          SizedBox(width: 4),
                          Text(
                            "Email",
                            style: TextStyle(
                              color: scheme.onSurfaceVariant
                            ),
                          )
                        ],
                      ),
                      Text("user@gmail.com")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: scheme.outline
                    ),
                    color: scheme.surface
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 4),
                          Text(
                            "Telefone",
                            style: TextStyle(
                              color: scheme.onSurfaceVariant
                            ),
                          )
                        ],
                      ),
                      Text("+55 47 91234-4321")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: scheme.outline
                    ),
                    color: scheme.surface
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 4),
                          Text(
                            "Endereço",
                            style: TextStyle(
                              color: scheme.onSurfaceVariant
                            ),
                          )
                        ],
                      ),
                      Text("Rua das Flores, 123")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Serviços",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: scheme.outline
                      ),
                      color: scheme.surface
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.error),
                            SizedBox(width: 4),
                            Text(
                              "Central de ajuda",
                              style: TextStyle(
                                color: scheme.onSurfaceVariant
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: GestureDetector(
                  onTap: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: "Tem certeza que deseja fazer logout?",
                        description: null,
                      )
                    ) ?? false;

                    if (!ok) return;
                    ref.read(authControllerProvider.notifier).logout();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: scheme.outline
                      ),
                      color: scheme.surface
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 4),
                            Text(
                              "Sair",
                              style: TextStyle(
                                color: scheme.onSurfaceVariant
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
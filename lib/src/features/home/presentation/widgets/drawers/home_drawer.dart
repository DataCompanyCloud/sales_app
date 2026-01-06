import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/faq/presentation/router/faq_router.dart';
import 'package:sales_app/src/features/myProfile/presentation/router/my_profile_router.dart';
import 'package:sales_app/src/features/settings/presentation/router/settings_router.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authControllerProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: 322,
      height: double.infinity,
      color: scheme.surface,
      child: controller.when(
        error: (error, stack) {
          return Text(error.toString());
        },
        loading: () {
          return CircularProgressIndicator();
        },
        data: (user) {
          if (user == null) {
            return Text("Usuário nulo");
          }
          return  SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(right: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: scheme.surface,
                          )
                        )
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.pushNamed(MyProfileRouter.myProfile.name);
                  },
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                  title: Text(
                    user.userName,
                  ),
                  subtitle: Text(
                    user.userCode,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "SERVIÇOS",
                  ),
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        height: 8,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: SizedBox(
                    height: 34,
                    width: 34,
                    child: Icon(
                      Icons.person_pin,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    "Meu perfil",
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.pushNamed(MyProfileRouter.myProfile.name);
                  },
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        height: 8,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: SizedBox(
                    height: 34,
                    width: 34,
                    child: Icon(
                      Icons.chat,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    "FAQ",
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.pushNamed(FaqRouter.faq.name);
                  },
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        height: 8,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: SizedBox(
                    height: 34,
                    width: 34,
                    child: Icon(
                      Icons.settings,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    "Configurações",
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.pushNamed(SettingsRouter.settings.name);
                  },
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "CONTA",
                    style: TextStyle(
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        height: 8,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: SizedBox(
                    height: 34,
                    width: 34,
                    child: Icon(
                      Icons.logout_outlined,
                      size: 28,
                    ),
                  ),
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
                  title: Text(
                    "Sair",
                  ),
                ),
              ]
            )
          );
        }
      )
    );
  }
}
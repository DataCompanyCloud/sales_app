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
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          )
                        )
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    context.pushNamed(MyProfileRouter.myProfile.name);
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    user.userName,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    user.userCode,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Serviços".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white70
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
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
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    "Meu perfil",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    context.pushNamed(MyProfileRouter.myProfile.name);
                  },
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
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
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    "FAQ",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    context.pushNamed(FaqRouter.faq.name);
                  },
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
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
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    "Configurações",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    context.pushNamed(SettingsRouter.settings.name);
                  },
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Conta".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white70
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
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
                      color: Colors.white,
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
                    style: TextStyle(color: Colors.white),
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
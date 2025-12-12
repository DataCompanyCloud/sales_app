import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/settings/presentation/router/settings_router.dart';

final isDarkModeEnabledProvider = StateProvider<bool>((ref) => false);
final isNotificationsOnProvider = StateProvider<bool>((ref) => false);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeEnabledProvider);
    final isNotificationsOn = ref.watch(isNotificationsOnProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Geral".toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Habilitar notificações do app"),
                        leading: Icon(Icons.notifications),
                        trailing: Switch(
                          value: isNotificationsOn,
                          onChanged: (newValue) {
                            ref.read(isNotificationsOnProvider.notifier).state = newValue;
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 12),
                    child: Text(
                      "Segurança".toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Alterar senha"),
                        leading: Icon(Icons.lock),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 12),
                    child: Text(
                      "Tema".toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Tamanho da fonte"),
                        leading: Icon(Icons.text_increase),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Pequeno",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text("Tema escuro"),
                        leading: Icon(Icons.nightlight),
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (newValue) {
                            ref.read(isDarkModeEnabledProvider.notifier).state = newValue;
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 12),
                    child: Text(
                      "Sobre".toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Fale conosco"),
                        leading: Icon(Icons.phone_in_talk),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text("Termos de uso"),
                        leading: Icon(Icons.list_alt),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text("Política de privacidade"),
                        leading: Icon(Icons.shield),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context.goNamed(SettingsRouter.privacy_policy.name);
                        },
                      ),
                      // ListTile(
                      //   title: Text("Versão"),
                      //   leading: Icon(Icons.error_outline),
                      //   trailing: Text(
                      //     "v0.0.1",
                      //     style: TextStyle(
                      //       fontSize: 15,
                      //       color: Colors.grey
                      //     ),
                      //   ),
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 12),
                    child: Text(
                      "Outros".toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Mais opções"),
                        leading: Icon(Icons.settings),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context.pushNamed(SettingsRouter.more_settings.name);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
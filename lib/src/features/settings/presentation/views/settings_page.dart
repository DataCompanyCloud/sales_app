import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/settings/presentation/router/settings_router.dart';
import 'package:url_launcher/url_launcher.dart';

final isNotificationsOnProvider = StateProvider<bool>((ref) => false);
final isLoadingWhatsAppProvider = StateProvider<bool>((ref) => false);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLoadingWhatsApp = ref.watch(isLoadingWhatsAppProvider);
    final isNotificationsOn = ref.watch(isNotificationsOnProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        leading: IconButton(
          onPressed: () {
            context.goNamed(AppRoutes.home.name);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: scheme.outline,
            height: 1.0,
          ),
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
                        onTap: isLoadingWhatsApp
                        ? null
                        : () async {
                          await openWhatsApp();
                        },
                      ),
                      ListTile(
                        title: Text("Termos de uso"),
                        leading: Icon(Icons.list_alt),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context.goNamed(SettingsRouter.use_terms.name);
                        },
                      ),
                      ListTile(
                        title: Text("Política de privacidade"),
                        leading: Icon(Icons.shield),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context.goNamed(SettingsRouter.privacy_policy.name);
                        },
                      ),
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

Future<void> openWhatsApp() async {
  const String phone = '5547992284400';
  const String msg = 'Olá, preciso de ajuda.';

  final Uri url = Uri.parse(
    'https://wa.me/$phone?text=${Uri.encodeComponent(msg)}',
  );

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Não foi possível abrir o WhatsApp';
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final isWifiOnlyProvider = StateProvider<bool>((ref) => false);
final isDarkModeEnabledProvider = StateProvider<bool>((ref) => false);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWifiOnly = ref.watch(isWifiOnlyProvider);
    final isDarkMode = ref.watch(isDarkModeEnabledProvider);

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
      body: Padding(
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
                    title: Text("Mudar local dos arquivos"),
                    leading: Icon(Icons.file_open),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  SwitchListTile(
                    title: Text("Baixar arquivos somente \ncom Wi-Fi"),
                    secondary: Icon(Icons.wifi),
                    value: isWifiOnly,
                    onChanged: (newValue) {
                      ref.read(isWifiOnlyProvider.notifier).state = newValue;
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
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  SwitchListTile(
                    title: Text("Tema escuro"),
                    secondary: Icon(Icons.nightlight),
                    value: isDarkMode,
                    onChanged: (newValue) {
                      ref.read(isDarkModeEnabledProvider.notifier).state = newValue;
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
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
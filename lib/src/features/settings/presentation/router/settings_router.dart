import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/settings/presentation/views/settings_page.dart';

enum SettingsRouter {
  settings
}

final settingsRoutes = GoRoute(
  path: '/settings',
  name: SettingsRouter.settings.name,
  builder: (context, state) {
    return SettingsPage();
  }
);
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/settings/presentation/views/more_options_page.dart';
import 'package:sales_app/src/features/settings/presentation/views/settings_page.dart';

enum SettingsRouter {
  settings,
  more_settings
}

final settingsRoutes = GoRoute(
  path: '/settings',
  name: SettingsRouter.settings.name,
  builder: (context, state) {
    return SettingsPage();
  },
  routes: [
    GoRoute(
      path: 'more_settings',
      name: SettingsRouter.more_settings.name,
      builder: (context, state) {
        return MoreOptionsPage();
      }
    )
  ]
);
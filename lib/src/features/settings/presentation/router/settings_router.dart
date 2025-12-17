import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/settings/presentation/views/more_options_page.dart';
import 'package:sales_app/src/features/settings/presentation/views/privacy_policy_page.dart';
import 'package:sales_app/src/features/settings/presentation/views/settings_page.dart';
import 'package:sales_app/src/features/settings/presentation/views/terms_of_use_page.dart';

enum SettingsRouter {
  settings,
  more_settings,
  privacy_policy,
  use_terms,
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
      },
    ),
    GoRoute(
      path: 'privacy_policy',
      name: SettingsRouter.privacy_policy.name,
      builder: (context, state) {
        return PrivacyPolicyPage();
      }
    ),
    GoRoute(
      path: 'terms_of_use',
      name: SettingsRouter.use_terms.name,
      builder: (context, state) {
        return TermsOfUsePage();
      }
    )
  ]
);
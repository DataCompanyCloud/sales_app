import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/widgets/fade_transition.dart';
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
  pageBuilder: (ctx, state) {
    return fadePage(child: SettingsPage(), key: state.pageKey);
  },
  routes: [
    GoRoute(
      path: 'more_settings',
      name: SettingsRouter.more_settings.name,
      pageBuilder: (ctx, state) {
        return fadePage(child: MoreOptionsPage(), key: state.pageKey);
      },
    ),
    GoRoute(
      path: 'privacy_policy',
      name: SettingsRouter.privacy_policy.name,
      pageBuilder: (ctx, state) {
        return fadePage(child: PrivacyPolicyPage(), key: state.pageKey);
      }
    ),
    GoRoute(
      path: 'terms_of_use',
      name: SettingsRouter.use_terms.name,
      pageBuilder: (ctx, state) {
        return fadePage(child: TermsOfUsePage(), key: state.pageKey);
      }
    )
  ]
);
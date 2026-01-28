import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/widgets/fade_transition.dart';
import 'package:sales_app/src/features/myProfile/presentation/views/my_profile_page.dart';

enum MyProfileRouter {
  myProfile,
}

final myProfileRoutes = GoRoute(
  path: '/myProfile',
  name: MyProfileRouter.myProfile.name,
  pageBuilder: (ctx, state) {
    return fadePage(
      child: MyProfilePage(),
      key: state.pageKey
    );
  }
);
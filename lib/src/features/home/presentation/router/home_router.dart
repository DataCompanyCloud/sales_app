import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/widgets/fade_transition.dart';
import 'package:sales_app/src/features/home/presentation/views/home_page.dart';

enum HomeRouter {
  home,
}

final homeRoutes = GoRoute(
  path: '/home',
  name: HomeRouter.home.name,
  pageBuilder: (ctx, state) => fadePage(child: HomePage(title: "Início"), key: state.pageKey),
);
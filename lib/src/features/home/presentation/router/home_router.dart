import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/presentation/views/home_page.dart';

enum HomeRouter {
  home,
}

final homeRoutes = GoRoute(
  path: '/home',
  name: HomeRouter.home.name,
  builder: (context, state) {
    return HomePage(title: "Início");
  },
);
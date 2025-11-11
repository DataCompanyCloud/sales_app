import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/faq/presentation/views/faq_page.dart';

enum FaqRouter {
  faq,
}

final faqRoutes = GoRoute(
  path: '/faq',
  name: FaqRouter.faq.name,
  builder: (context, state) {
    return FaqPage();
  }
);
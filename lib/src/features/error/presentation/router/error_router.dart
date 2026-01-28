import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/router/widgets/fade_transition.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';

enum ErrorRouter {
  error
}

final errorRoutes = GoRoute(
  path: '/error_page',
  name: ErrorRouter.error.name,
  pageBuilder: (ctx, state) {
    final exception = state.extra as AppException?;

    if (exception == null) {
      return fadePage(
        child: ErrorPage(exception: AppException.errorUnexpected("Conversão da exception falhou")),
        key: state.pageKey
      );
    }

    return fadePage(
      child: ErrorPage(exception: exception),
      key: state.pageKey
    );
  }
);
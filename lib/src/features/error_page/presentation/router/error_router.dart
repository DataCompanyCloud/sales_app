import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error_page/presentation/views/error_page.dart';

enum ErrorRouter {
  error
}

final errorRoutes = GoRoute(
  path: '/error_page',
  name: ErrorRouter.error.name,
  builder: (context, state) {
    final exception = state.extra as AppException?;

    if (exception == null) {
      return ErrorPage(exception: AppException.errorUnexpected("Conversão da exception falhou"));
    }

    return ErrorPage(exception: exception);
  }
);
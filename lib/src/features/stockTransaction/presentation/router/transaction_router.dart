import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/stockTransaction/presentation/views/transaction_page.dart';

enum MovementRouter {
  movement,
}

final movementRoutes = GoRoute(
  path: '/movement',
  name: MovementRouter.movement.name,
  builder: (context, state) {
    return TransactionPage();
  }
);
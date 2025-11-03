import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/stockTransaction/presentation/views/transaction_page.dart';

enum TransactionRouter {
  transaction,
}

final transactionRoutes = GoRoute(
  path: '/movement',
  name: TransactionRouter.transaction.name,
  builder: (context, state) {
    return TransactionPage();
  }
);
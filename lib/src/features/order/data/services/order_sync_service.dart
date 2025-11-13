import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/notifications/notification_service.dart';
import 'package:sales_app/src/features/order/domain/repositories/order_repository.dart';
import 'package:sales_app/src/features/order/domain/valueObjects/order_status.dart';

class OrderSyncService {
  final OrderRepository repository;
  final ApiClient apiClient;

  OrderSyncService(this.apiClient, this.repository);


   Future<void> syncOrders({ bool showNotification = true }) async {
    // final orderBox = store.box<OrderEntity>();

    final apiOrders = await repository.fetchAll(OrderFilter(status: OrderStatus.draft));
    final total = apiOrders.length;

    if (total == 0) {
      if (showNotification) {
        await NotificationService.completeSyncNotification(
          title: 'Pedidos sincronizados',
          body: 'Nenhum pedido novo',
        );
      }
      return;
    }

    int processed = 0;

    if (showNotification) {
      await NotificationService.showSyncNotification(
        title: 'Sincronizando pedidos',
        body: '0 de $total concluídos',
        progress: 0,
        maxProgress: total,
      );
    }


    // 3. Finalizou
    if (showNotification) {
      await NotificationService.completeSyncNotification(
        title: 'Sincronização concluída',
        body: '$total pedidos atualizados',
      );
    }
  }
}

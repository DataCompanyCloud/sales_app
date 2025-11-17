import 'package:faker/faker.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/notifications/notification_service.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/sales_order_repository.dart';

class SalesOrderSyncService {
  final SalesOrderRepository repository;
  final ApiClient apiClient;

  SalesOrderSyncService(this.apiClient, this.repository);


   Future<void> syncOrders({ bool showNotification = true }) async {

    final apiOrders = await repository.fetchAll(SalesOrderFilter(onlyPendingSync: true));
    final total = apiOrders.length;

    if (total == 0) {
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


    // Loop simulando processamento pedido a pedido
    for (final order in apiOrders) {
      // aqui você chamaria a API de fato, ex:
      // await apiClient.sendOrder(order);

      // simula um tempo aleatório entre 300ms e 1500ms
      final delayMs = 300 + random.integer(1200, min: 0);
      await Future.delayed(Duration(milliseconds: delayMs));

      processed++;

      if (showNotification) {
        await NotificationService.showSyncNotification(
          title: 'Sincronizando pedidos',
          body: '$processed de $total concluídos',
          progress: processed,
          maxProgress: total,
        );
      }
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

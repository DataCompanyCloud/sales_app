import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/notifications/notification_service.dart';
import 'package:sales_app/src/features/customer/domain/repositories/customer_repository.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_state.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_status.dart';
import 'package:sales_app/src/features/settings/providers.dart';

class SyncCustomersNotifier extends AsyncNotifier<SyncState> {
  static const channel = "sync_customer";
  static const channelDescription = "Sincronizando clientes";

  @override
  SyncState build() {
    return SyncState();
  }

  Future<void> syncCustomers() async {
    if (state.isLoading) return;
    state = AsyncData(SyncState(status: SyncStatus.preparing));
    state = const AsyncLoading();

    final service = await ref.read(customerServiceProvider.future);
    final repository = await ref.read(customerRepositoryProvider.future);
    try {

      await NotificationService.initialSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização iniciada",
        body: "Preparando sincronização"
      );

      final filter = CustomerFilter();
      int count = await repository.count();
      while (true) {
        final pagination = await service.getAll(filter.copyWith(start: count));
        final total = pagination.total;
        final customers = pagination.items;

        if (customers.isEmpty) {
          // Nada mais para processar → encerra
          break;
        }

        state = AsyncData(state.value!.copyWith(status: SyncStatus.syncing, total: total));

        for (final customer in customers) {
          var toSave = customer;

          await repository.save(toSave);
          state = AsyncData(state.value!.copyWith(itemsSyncAmount: count++ ));
          ref.read(currentDownloadingCustomerProvider.notifier).state = toSave;

          await NotificationService.showSyncNotification(
            channel: channel,
            channelDescription: channelDescription,
            title: "Sincronização iniciada",
            body: "Baixando clientes",
            progress: count,
            maxProgress: total,
          );
        }

        if (count >= total) {
          // Já processou tudo → encerra
          break;
        }
      }

      await NotificationService.completeSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização concluída",
        body: "Todos os clientes foram baixados com sucesso!",
      );

      state = AsyncData(state.value!.copyWith( status: SyncStatus.complete ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

}

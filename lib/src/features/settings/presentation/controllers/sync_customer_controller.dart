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

      final limit = 20;
      final totalLocal = await repository.count();
      final start = 0;
      final total = await service.getCount(CustomerFilter());

      if (total == totalLocal) {

        await NotificationService.completeSyncNotification(
          channel: channel,
          channelDescription: channelDescription,
          title: "Sincronização concluída",
          body: "Todos os clientes foram baixados com sucesso!"
        );

        state = AsyncData(state.value!.copyWith(status: SyncStatus.complete));
        return;
      }

      state = AsyncData(state.value!.copyWith(status: SyncStatus.syncing, total: total));

      int count = start;
      await NotificationService.showSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização iniciada",
        body: "Baixando clientes",
        progress: count,
        maxProgress: total,
      );

      for (int i = start; i < total; i += limit) {

        final cancelSync = ref.read(cancelCustomerSyncProvider);
        if (cancelSync) {
          NotificationService.completeSyncNotification(
            channel: channel,
            channelDescription: channelDescription,
            title: "Donwload cancelado",
            body: "O download foi interrompido pelo usuário.",
          );

          ref.read(cancelCustomerSyncProvider.notifier).state = false;
          state = AsyncData(state.value!.copyWith(status: SyncStatus.cancel, total: total));
          return;
        }

        final customers = await service.getAll(
          CustomerFilter(start: i, limit: limit),
        );

        for (var customer in customers) {
          state = AsyncData(state.value!.copyWith(itemsSyncAmount: count ++));

          var newCustomer = customer.copyWith();
          ref.read(currentDownloadingCustomerProvider.notifier).state = newCustomer;
          await repository.save(newCustomer);

          await NotificationService.showSyncNotification(
            channel: channel,
            channelDescription: channelDescription,
            title: "Sincronizando clientes",
            body: "Baixando...",
            progress: count,
            maxProgress: total,
          );
        }
      }

      await NotificationService.completeSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização concluída",
        body: "Todos os clientes foram baixados com sucesso!",
      );

      state = AsyncData(state.value!.copyWith(status: SyncStatus.complete));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }


}

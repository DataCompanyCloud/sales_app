import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/notifications/notification_service.dart';
import 'package:sales_app/src/features/customer/domain/repositories/customer_repository.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_state.dart';
import 'package:sales_app/src/features/settings/providers.dart';

class SyncCustomersNotifier extends AsyncNotifier<SyncState> {
  static const channel = "sync_customer";
  static const channelDescription = "Sincronizando clientes";

  @override
  SyncState build() {
    return SyncState();
  }

  Future<void> syncCustomers() async {
    state = AsyncData(SyncState());
    final syncValue = state.value;

    if (syncValue == null || syncValue.isSyncing == true) return;

    if (state.value?.isSyncing == true) return;

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
      print(start);
      final total = await service.getCount(CustomerFilter());

      if (total == totalLocal) {

        await NotificationService.completeSyncNotification(
          channel: channel,
          channelDescription: channelDescription,
          title: "Sincronização concluída",
          body: "Todos os produtos foram baixados com sucesso!"
        );

        state = AsyncData(state.value!.copyWith(isSyncing: false, lastSync: DateTime.now()));
        return;
      }

      await Future.delayed(Duration(seconds: 5));

      state = AsyncData(syncValue.copyWith(isSyncing: true, total: total));

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

        final cancelSync = ref.read(cancelSyncProvider);
        if (cancelSync) {
          NotificationService.completeSyncNotification(
            channel: channel,
            channelDescription: channelDescription,
            title: "Donwload cancelado",
            body: "O download foi interrompido pelo usuário.",
          );

          ref.read(cancelSyncProvider.notifier).state = false;
          state = AsyncData(state.value!.copyWith(isSyncing: false, lastSync: DateTime.now()));
          return;
        }

        final customers = await service.getAll(
          CustomerFilter(start: i, limit: limit),
        );

        for (var customer in customers) {

          state = AsyncData(state.value!.copyWith(itemsSyncAmount: count ++));

          var newCustomer = customer.copyWith();
          ref.read(currentDownloadingCustomerProvider.notifier).state = newCustomer;
          // TODO: Revisar porque a função save não está funcionando
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

      state = AsyncData(state.value!.copyWith(isSyncing: false, lastSync: DateTime.now()));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

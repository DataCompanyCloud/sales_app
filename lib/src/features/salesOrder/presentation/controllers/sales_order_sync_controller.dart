import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderSyncController extends AutoDisposeFamilyAsyncNotifier<SalesOrder?, String?> {

  @override
  Future<SalesOrder?> build(String? uuid) async {
    if (uuid == null) return null;

    final isConnected = ref.read(isConnectedProvider);
    // Se não está conectado → não sincroniza
    if (!isConnected) return null;

    try {
      final repository = await ref.read(salesOrderRepositoryProvider.future);
      final remote = await repository.fetchByUuId(uuid);

      final service = await ref.read(salesOrderServiceProvider.future);
      await service.save(remote);

      return remote;

    } catch (e, stack) {
      // AsyncNotifier espera que você jogue o erro
      throw AsyncError(e, stack);
    }
  }
}
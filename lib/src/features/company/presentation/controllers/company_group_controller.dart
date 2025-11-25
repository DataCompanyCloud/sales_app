import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/company/domain/entities/company_group.dart';
import 'package:sales_app/src/features/company/providers.dart';

class CompanyGroupController extends AutoDisposeAsyncNotifier<List<CompanyGroup>>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<List<CompanyGroup>> build() async {
    final filter = ref.watch(companyGroupFilterProvider);
    final repository = await ref.read(companyGroupRepositoryProvider.future);
    state = AsyncLoading();
    final isConnected = ref.read(isConnectedProvider);

    // Tenta sincronizar com a API (se possível)
    if (isConnected) {
      try {
        final service = await ref.read(companyGroupServiceProvider.future);
        final newCustomers = await service.getAll(filter);

        if (newCustomers.isNotEmpty) {
          await repository.saveAll(newCustomers); // Atualiza cache local
        }
      } catch (e) {
        print(e);
      }
    }

    // Sempre retorna a lista do banco local (fonte da verdade)
    return await repository.fetchAll(filter);
  }
}
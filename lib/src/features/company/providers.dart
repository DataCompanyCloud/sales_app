import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/core/providers/datasource_provider.dart';
import 'package:sales_app/src/features/company/data/repositories/company_group_repository_impl.dart';
import 'package:sales_app/src/features/company/data/services/company_group_service.dart';
import 'package:sales_app/src/features/company/domain/entities/company.dart';
import 'package:sales_app/src/features/company/domain/entities/company_group.dart';
import 'package:sales_app/src/features/company/domain/repositories/company_group_repository.dart';
import 'package:sales_app/src/features/company/domain/useCases/set_primary_company_usecase.dart';
import 'package:sales_app/src/features/company/presentation/controllers/company_group_controller.dart';

final companyGroupRepositoryProvider = FutureProvider.autoDispose<CompanyGroupRepository>((ref) async {
  final store = await ref.watch(datasourceProvider.future);
  return CompanyGroupRepositoryImpl(store);
});

final companyGroupFilterProvider = StateProvider.autoDispose<CompanyGroupFilter>((ref) {
  return CompanyGroupFilter(start: 0, limit: 30);
});

final companyGroupServiceProvider = FutureProvider<CompanyGroupService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return CompanyGroupService(apiClient);
});


final companyGroupControllerProvider = AutoDisposeAsyncNotifierProvider<CompanyGroupController, List<CompanyGroup>>(
  CompanyGroupController.new,
);

final activeCompanyProvider = Provider<Company?>((ref) {
  final groupAsync = ref.watch(companyGroupControllerProvider);

  return groupAsync.maybeWhen(
    data: (groups) {
      for (final group in groups) {
        final primary = group.primaryCompany;
        if (primary != null) {
          return primary;
        }
      }
      return null;
    },
    orElse: () => null,
  );
});

final setPrimaryCompanyUseCaseProvider = Provider<SetPrimaryCompanyUseCase>((ref) {
  return SetPrimaryCompanyUseCase();
});

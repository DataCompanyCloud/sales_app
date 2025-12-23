import 'package:sales_app/src/features/company/domain/entities/company_group.dart';

class SetPrimaryCompanyUseCase {
  List<CompanyGroup> call({
    required List<CompanyGroup> groups,
    required int groupId,
    required int companyId,
  }) {
    return groups.map((group) {
      if (group.groupId != groupId) return group;

      return group.copyWith(
        companies: group.companies.map((company) {
          return company.copyWith(
            isPrimary: company.companyId == companyId,
          );
        }).toList(),
      );
    }).toList();
  }
}

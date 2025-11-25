import 'package:sales_app/src/features/company/domain/entities/company_group.dart';

enum CompanyDirection { asc, desc }

class CompanyGroupFilter {
  final int start;
  final int limit;
  final String? q;
  final CompanyDirection direction;

  const CompanyGroupFilter({
    this.start = 0,
    this.limit = 20,
    this.q,
    this.direction = CompanyDirection.desc,
  });
}


abstract class CompanyGroupRepository {
  Future<List<CompanyGroup>> fetchAll(CompanyGroupFilter filter);
  Future<CompanyGroup> fetchById(int companyId);
  Future<void> saveAll(List<CompanyGroup> companies);
  Future<CompanyGroup> save(CompanyGroup group);
  Future<void> delete(CompanyGroup company);
  Future<void> deleteAll();
  Future<int> count();
}
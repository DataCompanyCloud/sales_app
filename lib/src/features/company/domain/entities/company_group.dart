import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/company/domain/entities/company.dart';

part 'company_group.freezed.dart';
part 'company_group.g.dart';

@freezed
abstract class CompanyGroup with _$CompanyGroup {
  const CompanyGroup._();

  const factory CompanyGroup ({
    required int groupId,
    @Default([]) List<Company> companies,
  }) = _CompanyGroup;

  factory CompanyGroup.fromJson(Map<String, dynamic> json) => _$CompanyGroupFromJson(json);

  Company? get primaryCompany {
    if (companies.isEmpty) return null;
    return companies.firstWhere(
      (c) => c.isPrimary,
      orElse: () => companies.first,
    );
  }
}
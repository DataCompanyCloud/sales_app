import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
abstract class Company with _$Company {
  const factory Company ({
    required int companyId,
    required String tradeName,
    required String realName,
    required CNPJ cnpj,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}
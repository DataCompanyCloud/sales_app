import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../customer/domain/valueObjects/cnpj.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
abstract class Company with _$Company {
  const factory Company ({
    required int id,
    required String name,
    CNPJ? cnpj,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}
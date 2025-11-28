import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
abstract class Company with _$Company {
  const factory Company ({
    required int companyId,
    required String tradeName,
    required String realName,
    @Default(false) bool isPrimary,
    @CnpjConverter() required CNPJ cnpj,
    required Address address,
    required TaxRegime taxRegime,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  /// Cria um contexto de impostos, Com base na empresa e no cliente

}
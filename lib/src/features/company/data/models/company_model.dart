import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/company/domain/entities/company.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';

@Entity()
class CompanyModel {
  @Id()
  int id;                 // local

  final int companyId;
  final String tradeName;
  final String realName;
  final String cnpj;
  final bool isPrimary;
  final int taxRegime;

  final address = ToOne<AddressModel>();

  CompanyModel({
    this.id = 0,
    required this.companyId,
    required this.tradeName,
    required this.realName,
    required this.cnpj,
    required this.isPrimary,
    required this.taxRegime
  });
}

extension CompanyModelMapper on CompanyModel {
  Company toEntity() {
    return Company(
      tradeName: tradeName,
      realName: realName,
      cnpj: CNPJ(value: cnpj),
      companyId: companyId,
      address: address.target!.toEntity(),
      isPrimary: isPrimary,
      taxRegime: TaxRegime.values[taxRegime]
    );
  }

  /// Remove este CompanyModel e todas as entidades relacionadas.
  void deleteRecursively({
    required Box<CompanyModel> companyBox,
    required Box<AddressModel> addressBox
  }) {

    if (address.target != null) {
      addressBox.remove(address.targetId);
    }

    companyBox.remove(id);
  }
}

extension CompanyMapper on Company {
  CompanyModel toModel() {
    final model = CompanyModel(
      companyId: companyId,
      cnpj: cnpj.value,
      realName: realName,
      tradeName: tradeName,
      isPrimary: isPrimary,
      taxRegime: taxRegime.index
    );

    model.address.target = address.toModel();

    return model;
  }
}

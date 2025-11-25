import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/company/data/models/company_model.dart';
import 'package:sales_app/src/features/company/domain/entities/company_group.dart';
import 'package:sales_app/src/features/customer/data/models/address_model.dart';

@Entity()
class CompanyGroupModel {
  @Id()
  int id;

  final int groupId;
  final companies = ToMany<CompanyModel>();

  CompanyGroupModel({
    this.id = 0,
    required this.groupId
  });
}

extension CompanyGroupModelMapper on CompanyGroupModel {
  CompanyGroup toEntity() {
    return CompanyGroup(
      groupId: groupId,
      companies: companies.map((c) => c.toEntity()).toList()
    );
  }

  /// Remove este CompanyGroupModel e todas as entidades relacionadas.
  void deleteRecursively({
    required Box<CompanyGroupModel> companyGroupBox,
    required Box<CompanyModel> companyBox,
    required Box<AddressModel> addressBox
  }) {

    for ( var company in companies) {
      company.deleteRecursively(companyBox: companyBox, addressBox: addressBox);
    }

    companyGroupBox.remove(id);
  }
}

extension CompanyGroupMapper on CompanyGroup {
  CompanyGroupModel toModel() {
    final model = CompanyGroupModel(
       groupId: groupId
    );

    if (companies.isNotEmpty) {
      model.companies.addAll(companies.map((p) => p.toModel()));
    }

    return model;
  }
}

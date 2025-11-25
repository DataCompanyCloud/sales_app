import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/product/data/models/product_fiscal_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_product_model.dart';
import 'package:sales_app/src/features/salesOrder/data/models/tax_context_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_company_group.dart';

@Entity()
class SalesOrderCompanyGroupModel {
  @Id()
  int id;

  final int groupId;
  final items = ToMany<SalesOrderProductModel>();
  final context = ToOne<TaxContextModel>();

  SalesOrderCompanyGroupModel({
    this.id = 0,
    required this.groupId
  });
}

extension SalesOrderCompanyGroupModelMapper on SalesOrderCompanyGroupModel {
  SalesOrderCompanyGroup toEntity() {
    final itemsList = items.map((i) => i.toEntity()).toList();

    return SalesOrderCompanyGroup(
      companyId: groupId,
      items: itemsList,
      context: context.target?.toEntity()
    );
  }


  void deleteRecursively({
    required Box<SalesOrderCompanyGroupModel> salesOrderCompanyGroupBox,
    required Box<SalesOrderProductModel> salesOrderProductBox,
    required Box<MoneyModel> moneyBox,
    required Box<ProductFiscalModel> productFiscalBox,
    required Box<TaxContextModel> taxContextModel
  }) {

    for (final item in items) {
      item.deleteRecursively(salesOrderProductBox, moneyBox, productFiscalBox);
    }

    if (context.target != null) {
      taxContextModel.remove(context.targetId);
    }

    salesOrderCompanyGroupBox.remove(id);
  }
}

extension SalesOrderCompanyGroupMapper on SalesOrderCompanyGroup {

  SalesOrderCompanyGroupModel toModel() {
    final entity = SalesOrderCompanyGroupModel(
      groupId: groupId
    );

    if (items.isNotEmpty) {
      entity.items.addAll(items.map((i) => i.toModel()));
    }

    entity.context.target = context?.toModel();

    return entity;
  }
}
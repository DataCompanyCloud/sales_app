import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/tax_context.dart';

part 'sales_order_company_group.freezed.dart';
part 'sales_order_company_group.g.dart';

@freezed
abstract class SalesOrderCompanyGroup with _$SalesOrderCompanyGroup{
  const SalesOrderCompanyGroup._();

  const factory SalesOrderCompanyGroup.raw({
    required int groupId,
    @Default([]) List<SalesOrderProduct> items,
    required TaxContext? context
  }) = _SalesOrderCompanyGroup;

  factory SalesOrderCompanyGroup({
    required int companyId,
    required List<SalesOrderProduct> items,
    required TaxContext? context
  }) {
    //TODO: Fazer as validações

    return SalesOrderCompanyGroup.raw(
      groupId: companyId,
      context: context,
      items: items
    );
  }

  factory SalesOrderCompanyGroup.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderCompanyGroupFromJson(json);

  @JsonKey(includeFromJson: false)
  Money get calcItemsSubtotal => items.fold(
    Money.zero(),
    (acc, it) => acc.plus(it.totalPrice),
  );


  SalesOrderCompanyGroup addItem(SalesOrderProduct item) {
    return copyWith(items: [...items, item]);
  }
}
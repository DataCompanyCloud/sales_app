import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_tax_result.freezed.dart';
part 'product_tax_result.g.dart';

@freezed
abstract class ProductTaxResult with _$ProductTaxResult {
  const ProductTaxResult._();

  const factory ProductTaxResult({
    required Money icmsBase,
    required Money icmsValue,
    required Percentage icmsAliquota,

    required Money icmsSTBase,
    required Money icmsSTValue,
    Percentage? mva,

    required Money ipiBase,
    required Money ipiValue,
    Percentage? ipiAliquota,

    required Money pisBase,
    required Money pisValue,
    required Percentage? pisAliquota,

    required Money cofinsBase,
    required Money cofinsValue,
    required Percentage? cofinsAliquota,

    required Money difalValue,
    required Money fcpValue,
    required Money totalTax,
  }) = _ProductTaxResult;


  factory ProductTaxResult.fromJson(Map<String, dynamic> json) =>
      _$ProductTaxResultFromJson(json);
}

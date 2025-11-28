import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';

part 'tax_icms.freezed.dart';
part 'tax_icms.g.dart';

@freezed
abstract class TaxIcms with _$TaxIcms {
  const TaxIcms._();

  const factory TaxIcms({
    @Default({}) Map<BrazilianState, Map<BrazilianState, Percentage>> taxes,
  }) = _TaxIcms;

  factory TaxIcms.fromJson(Map<String, dynamic> json) =>
      _$TaxIcmsFromJson(json);


  Percentage? getPercentage({
    required BrazilianState from,
    required BrazilianState to,
  }) {
    return taxes[from]?[to];
  }
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';

part 'tax_context.freezed.dart';
part 'tax_context.g.dart';

@freezed
abstract class TaxContext with _$TaxContext {
  const TaxContext._();

  const factory TaxContext({
    required BrazilianState ufOrigem,
    required BrazilianState ufDestino,
    required bool consumidorFinal,
    required bool contribuinte,
    required TaxRegime taxRegime,
    @PercentageConverter() Percentage? icmsInterestadual,  // 7%, 12% ou 4%
    @PercentageConverter() Percentage? icmsDestino,        // alíquota interna do estado destino
    @PercentageConverter() Percentage? fcp,                // 2%, 3%, 4% (varia por estado)
    @PercentageConverter() Percentage? mvaAjustada,        // MVA calculada por estado destino
  }) = _TaxContext;

  factory TaxContext.fromJson(Map<String, dynamic> json) =>
      _$TaxContextFromJson(json);

}
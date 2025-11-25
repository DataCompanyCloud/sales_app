import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';

part 'tax_context.freezed.dart';
part 'tax_context.g.dart';

@freezed
abstract class TaxContext with _$TaxContext {
  const TaxContext._();

  const factory TaxContext.raw({
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

  factory TaxContext({
    required BrazilianState ufOrigem,
    required BrazilianState ufDestino,
    required bool consumidorFinal,
    required bool contribuinte,
    required TaxRegime regime,
    Percentage? icmsInterestadual,  // 7%, 12% ou 4%
    Percentage? icmsDestino,        // alíquota interna do estado destino
    Percentage? fcp,                // 2%, 3%, 4% (varia por estado)
    Percentage? mvaAjustada,        // MVA calculada por estado destino
  }) {

    return TaxContext.raw(
      ufOrigem: ufOrigem,
      ufDestino: ufDestino,
      consumidorFinal: consumidorFinal,
      contribuinte: contribuinte,
      taxRegime: regime,
      icmsInterestadual: icmsInterestadual,  // 7%, 12% ou 4%
      icmsDestino: icmsDestino,        // alíquota interna do estado destino
      fcp: fcp,                // 2%, 3%, 4% (varia por estado)
      mvaAjustada: mvaAjustada,        // MVA calculada por estado destino
    );
  }

  factory TaxContext.fromJson(Map<String, dynamic> json) =>
      _$TaxContextFromJson(json);

}
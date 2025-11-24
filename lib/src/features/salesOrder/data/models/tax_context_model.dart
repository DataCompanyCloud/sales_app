

import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/tax_context.dart';

@Entity()
class TaxContextModel {
  @Id()
  int id;

  final int ufOrigem;
  final int ufDestino;
  bool consumidorFinal;
  bool contribuinte;
  int taxRegime;
  double? icmsInterestadual;
  double? icmsDestino;
  double? fcp;
  double? mvaAjustada;

  TaxContextModel ({
    this.id = 0,
    required this.ufOrigem,
    required this.ufDestino,
    required this.consumidorFinal,
    required this.contribuinte,
    required this.taxRegime,
    this.icmsInterestadual,
    this.icmsDestino,
    this.fcp,
    this.mvaAjustada,
  });
}

extension TaxContextModelMapper on TaxContextModel {
  TaxContext toEntity() {

    return TaxContext(
      ufOrigem: BrazilianState.values[ufOrigem],
      ufDestino: BrazilianState.values[ufDestino],
      consumidorFinal: consumidorFinal,
      contribuinte: contribuinte,
      regime: TaxRegime.values[taxRegime],
      icmsInterestadual: icmsInterestadual != null ? Percentage(value: icmsInterestadual!) : null,
      icmsDestino: icmsDestino != null ? Percentage(value: icmsDestino!) : null,
      fcp: fcp != null ? Percentage(value: fcp!) : null,
      mvaAjustada: mvaAjustada != null ? Percentage(value: mvaAjustada!) : null,
    );
  }
}

extension TaxContextMapper on TaxContext {
  TaxContextModel toModel() {

    final model = TaxContextModel(
      ufOrigem: ufOrigem.index,
      ufDestino: ufDestino.index,
      consumidorFinal: consumidorFinal,
      contribuinte: contribuinte,
      taxRegime: taxRegime.index,
      fcp: fcp?.value,
      icmsDestino: icmsDestino?.value,
      icmsInterestadual: icmsInterestadual?.value,
      mvaAjustada: mvaAjustada?.value
    );

    return model;
  }
}
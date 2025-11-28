import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/product_fiscal.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/product_tax_result.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/tax_context.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_tax_calculator.freezed.dart';
part 'product_tax_calculator.g.dart';

@freezed
/// ProductTaxCalculator
///
/// Responsável por realizar **todos os cálculos fiscais de um item**
/// antes da emissão da Nota Fiscal.
///
/// Esta classe combina:
///  - ProductFiscal (dados fiscais fixos do produto — NCM, CEST, IPI, ICMS interno…)
///  - TaxContext (dados fiscais da operação — empresa emissora + cliente)
///  - baseCalc do item (valor unitário × quantidade)
///
/// Ela:
///  ✔ calcula ICMS, IPI, PIS, COFINS, DIFAL, FCP e ICMS-ST
///  ✔ aplica regras por regime tributário (Simples, Presumido, Real)
///  ✔ respeita regras de ST, MVA, alíquotas interestaduais e internas
///  ✔ usa valores do contexto de operação e fiscais do produto
///
/// Importante:
///  ⚠ Esta classe **não deve ser persistida no banco de dados**.
///  ⚠ Ela representa **apenas a lógica de cálculo**, temporária.
///  ⚠ O resultado persistível deve ser criado via `buildResult()`
///     como um `ProductTaxResult`, que é estático e imutável.
///
/// Uso típico:
///  1. Enquanto o pedido está sendo montado → usar calcX() para exibir valores.
///  2. Quando o pedido é finalizado → chamar `buildResult()` para gerar
///     o snapshot fiscal e salvar em `SalesOrderProduct.taxResult`.
///  3. Após a emissão da NF-e → nunca recalcular este item (usar o Result salvo).
///
/// Em resumo:
///  → ProductTaxCalculator = **Cálculo dinâmico e temporário**
///  → ProductTaxResult     = **Valores finais, congelados e persistidos**
///
/// Seguindo essa separação, o sistema evita erros fiscais,
/// inconsistência de notas emitidas e recalculações proibidas pela SEFAZ.
abstract class ProductTaxCalculator with _$ProductTaxCalculator {
  const ProductTaxCalculator._();

  const factory ProductTaxCalculator({
    required ProductFiscal fiscal,
    required TaxContext context,
    required Money baseCalc,
  }) = _ProductTaxCalculator;

  factory ProductTaxCalculator.fromJson(Map<String, dynamic> json) =>
      _$ProductTaxCalculatorFromJson(json);

  Percentage? get pisAliquota {
    switch (context.taxRegime) {
      case TaxRegime.presumido:
        return Percentage(value: 0.65);
      case TaxRegime.real:
        return Percentage(value: 1.65);
      case TaxRegime.simples:
        return null;
    }
  }

  Percentage? get cofinsAliquota {
    switch (context.taxRegime) {
      case TaxRegime.presumido:
        return Percentage(value: 3.0);
      case TaxRegime.real:
        return Percentage(value: 7.6);
      case TaxRegime.simples:
        return null;
    }
  }

  // -------------------------
  // CÁLCULOS
  // -------------------------

  Money calcICMS() {
    if (context.ufOrigem == context.ufDestino) {
      return fiscal.icmsInterno.apply(baseCalc);
    }

    if (context.icmsInterestadual == null) return Money.zero();

    return context.icmsInterestadual!.apply(baseCalc);
  }

  Money calcICMSST() {
    if (!fiscal.hasST) return Money.zero();
    if (context.mvaAjustada == null) return Money.zero();

    final mvaFactor = 1 + context.mvaAjustada!.value / 100;
    final baseST = baseCalc.multiply(mvaFactor);

    final icmsST = fiscal.icmsInterno.apply(baseST);
    final icmsOperacao = calcICMS();

    final st = icmsST.minus(icmsOperacao);
    return st.amount > 0 ? st : Money.zero();
  }

  Money calcIPI() {
    if (fiscal.ipi == null) return Money.zero();
    return fiscal.ipi!.apply(baseCalc);
  }

  Money calcPIS() {
    final aliquota = pisAliquota;
    if (aliquota == null) return Money.zero();
    return aliquota.apply(baseCalc);
  }

  Money calcCOFINS() {
    final aliquota = cofinsAliquota;
    if (aliquota == null) return Money.zero();
    return aliquota.apply(baseCalc);
  }

  Money calcDIFAL() {
    if (!context.consumidorFinal) return Money.zero();
    if (context.ufOrigem == context.ufDestino) return Money.zero();
    if (context.icmsDestino == null || context.icmsInterestadual == null) {
      return Money.zero();
    }
    final origem = context.icmsInterestadual!.apply(baseCalc);
    final destino = context.icmsDestino!.apply(baseCalc);
    final difal = destino.minus(origem);
    return difal.amount > 0 ? difal : Money.zero();
  }

  Money calcFCP() {
    if (context.fcp == null) return Money.zero();
    return context.fcp!.apply(baseCalc);
  }


  ProductTaxResult buildResult() {
    final icmsValue = calcICMS();
    final ipiValue = calcIPI();
    final pisValue = calcPIS();
    final cofinsValue = calcCOFINS();
    final difalValue = calcDIFAL();
    final fcpValue = calcFCP();
    final stValue = calcICMSST();

    final totalTax = icmsValue
        .plus(ipiValue)
        .plus(pisValue)
        .plus(cofinsValue)
        .plus(difalValue)
        .plus(fcpValue)
        .plus(stValue);

    return ProductTaxResult(
      icmsBase: baseCalc,
      icmsValue: icmsValue,
      icmsAliquota: context.icmsInterestadual ?? fiscal.icmsInterno,

      icmsSTBase: baseCalc,
      icmsSTValue: stValue,
      mva: context.mvaAjustada,

      ipiBase: baseCalc,
      ipiValue: ipiValue,
      ipiAliquota: fiscal.ipi,

      pisBase: baseCalc,
      pisValue: pisValue,
      pisAliquota: pisAliquota,

      cofinsBase: baseCalc,
      cofinsValue: cofinsValue,
      cofinsAliquota: cofinsAliquota,

      difalValue: difalValue,
      fcpValue: fcpValue,

      totalTax: totalTax,
    );
  }
}

// import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';
// import 'package:sales_app/src/features/company/domain/valueObjects/tax_regime.dart';
// import 'package:sales_app/src/features/product/domain/entities/product.dart';
// import 'package:sales_app/src/features/product/domain/valueObjects/product_fiscal.dart';
// import 'package:sales_app/src/features/salesOrder/domain/valueObjects/tax_context.dart';
//
//
// /// Calcula tudo com Money + Percentage, sem erros de double
// class TaxCalculator {
//
//   /// ICMS da operação (interna ou interestadual)
//   static Money calcICMS(Product product, TaxContext context) {
//     final fiscal = product.fiscal;
//
//     // Operação interna
//     if (context.ufOrigem == context.ufDestino) {
//       return fiscal.icmsInterno.apply(product.price);
//     }
//
//     // Operação interestadual:
//     if (context.icmsInterestadual == null) return Money.zero();
//     return context.icmsInterestadual!.apply(product.price);
//   }
//
//
//   /// DIFAL (consumidor final)
//   static Money calcDIFAL(ProductFiscal pf, TaxContext ctx, Money price) {
//     if (!ctx.consumidorFinal) return Money.zero();
//     if (ctx.ufOrigem == ctx.ufDestino) return Money.zero();
//     if (ctx.icmsInterestadual == null || ctx.icmsDestino == null) {
//       return Money.zero();
//     }
//
//     final origem = ctx.icmsInterestadual!.apply(price);
//     final destino = ctx.icmsDestino!.apply(price);
//     final difal = destino.minus(origem);
//
//     return difal.amount > 0 ? difal : Money.zero();
//   }
//
//   /// FCP (estado destino)
//   static Money calcFCP(ProductFiscal pf, TaxContext ctx, Money price) {
//     if (ctx.fcp == null) return Money.zero();
//     return ctx.fcp!.apply(price);
//   }
//
//   /// IPI
//   static Money calcIPI(ProductFiscal pf, TaxContext ctx, Money price) {
//     if (pf.ipi == null) return Money.zero();
//     return pf.ipi!.apply(price);
//   }
//
//
//   /// ICMS-ST (Depende da MVA ajustada)
//   // static Money calcICMSST(ProductFiscal pf, TaxContext ctx, Money price) {
//   //   if (!pf.hasST) return Money.zero();
//   //   if (ctx.mvaAjustada == null) return Money.zero();
//   //
//   //   final baseST = price.multiply(1 + ctx.mvaAjustada!.value / 100);
//   //   final icmsST = pf.icmsInterno.apply(baseST);
//   //
//   //   final icmsOperacao = calcICMS(pf, ctx, price);
//   //
//   //   final st = icmsST.minus(icmsOperacao);
//   //
//   //   return st.amount > 0 ? st : Money.zero();
//   // }
//
//   /// PIS (depende do regime tributário)
//   static Money calcPIS(TaxContext ctx, Money price) {
//     switch (ctx.regime) {
//       case TaxRegime.simples:
//         return Money.zero();
//       case TaxRegime.presumido:
//         return Percentage(value: 0.65).apply(price);
//       case TaxRegime.real:
//         return Percentage(value: 1.65).apply(price);
//     }
//   }
//
//   /// COFINS (depende do regime tributário)
//   static Money calcCOFINS(TaxContext ctx, Money price) {
//     switch (ctx.regime) {
//       case TaxRegime.simples:
//         return Money.zero();
//       case TaxRegime.presumido:
//         return Percentage(value: 3.0).apply(price);
//       case TaxRegime.real:
//         return Percentage(value: 7.6).apply(price);
//     }
//   }
//
//   // ------------------------------
//   // Resumo completo
//   // ------------------------------
//   static Map<String, Money> calculateAll(Product pf, TaxContext ctx, Money price) {
//     return {
//       // "ICMS": calcICMS(pf, ctx, price),
//       // "IPI": calcIPI(pf, ctx, price),
//       // "PIS": calcPIS(ctx, price),
//       // "COFINS": calcCOFINS(ctx, price),
//       // "DIFAL": calcDIFAL(pf, ctx, price),
//       // "FCP": calcFCP(pf, ctx, price),
//       // "ICMS-ST": calcICMSST(pf, ctx, price),
//     };
//   }
// }

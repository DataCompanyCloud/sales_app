import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';


part 'product_fiscal.freezed.dart';
part 'product_fiscal.g.dart';

@freezed
/// cadastrado uma vez, impostos fiscais pertencente ao produto
abstract class ProductFiscal with _$ProductFiscal {
  const ProductFiscal._();

  const factory ProductFiscal({
    required String ncm,           // natureza da mercadoria
    String? cest,                  // necessário para ST
    required int origem,           // 0..8
    @PercentageConverter() required Percentage icmsInterno,
    @PercentageConverter() Percentage? ipi,
    @Default(false) bool hasST,    // se pode ter ST
    @PercentageConverter() Percentage? mvaOriginal, // se você quiser guardar a "MVA base" aqui
    String? csosn,                 // opcional
    String? cst,                   // opcional
  }) = _ProductFiscal;

  factory ProductFiscal.fromJson(Map<String, dynamic> json) =>
      _$ProductFiscalFromJson(json);
}

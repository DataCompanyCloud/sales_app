import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';


part 'product_fiscal.freezed.dart';
part 'product_fiscal.g.dart';

@freezed
/// cadastrado uma vez, impostos fiscais pertencente ao produto
abstract class ProductFiscal with _$ProductFiscal {
  const ProductFiscal._();

  const factory ProductFiscal({
    required String ncm,                // Define natureza
    String? cest,                       // Necessário para ST
    required int origem,                // 0..8 (nacional, importado, etc.)
    @PercentageConverter() required Percentage icmsInterno,    // alíquota interna do estado de origem
    @PercentageConverter() Percentage? ipi,                    // TIPI, pode ser null se isento
    @Default(false) bool hasST,         // se o produto pode ter ST
    @PercentageConverter() Percentage? mvaPadrao,              // MVA básica (não ajustada)
  }) = _ProductFiscal;


  factory ProductFiscal.fromJson(Map<String, dynamic> json) => _$ProductFiscalFromJson(json);
}

import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/percentage.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/product_fiscal.dart';

@Entity()
class ProductFiscalModel {
  @Id(assignable: true)
  int id;

  String ncm;
  String? cest;
  int origem;
  double icmsInterno;
  double? ipi;
  bool hasST;

  ProductFiscalModel({
    this.id = 0,
    required this.ncm,
    required this.cest,
    required this.origem,
    required this.icmsInterno,
    required this.ipi,
    required this.hasST,
  });
}

extension ProductFiscalModelMapper on ProductFiscalModel {
  ProductFiscal toEntity() {
    return ProductFiscal(
      ncm: ncm ,
      cest: cest ,
      origem: origem ,
      icmsInterno: Percentage(value: icmsInterno),
      ipi: ipi != null ? Percentage(value: ipi!) : null,
      hasST: hasST
    );
  }
}

extension ProductFiscalMapper on ProductFiscal {
  ProductFiscalModel toModel() {
    final model = ProductFiscalModel(
      ncm: ncm,
      cest: cest,
      origem: origem,
      icmsInterno: icmsInterno.value,
      ipi: ipi?.value,
      hasST: hasST
    );

    return model;
  }
}
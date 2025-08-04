import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cnpj.dart';

@Entity()
class CNPJModel {
  @Id()
  int id;

  @Unique()
  String value;

  CNPJModel ({
    this.id = 0,
    required this.value
  });
}

extension CNPJModelMapper on CNPJModel {
  /// De CNPJModel → CNPJ
  CNPJ toEntity() => CNPJ(value: value);
}

extension CNPJMapper on CNPJ {
  /// De CNPJ → CNPJModel
  CNPJModel toModel() => CNPJModel(value: value);
}
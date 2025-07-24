import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/entities/cpf.dart';

@Entity()
class CPFModel {
  @Id()
  int id;

  @Unique()
  String value;

  CPFModel ({
    this.id = 0,
    required this.value
  });
}

extension CPFModelMapper on CPFModel {
  /// De CPFModel → CPF
  CPF toEntity() => CPF(value: value);
}

extension CPFMapper on CPF {
  /// De CPF → CPFModel
  CPFModel toModel() => CPFModel(value: value);
}

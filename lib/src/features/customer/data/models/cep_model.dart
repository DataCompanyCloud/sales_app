import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';

@Entity()
class CEPModel{
  @Id()
  int id;

  @Index()
  String value;

  CEPModel({
    this.id = 0,
    required this.value
  });
}

extension CEPModelMapper on CEPModel {
  /// De CEPModel → CEP
  CEP toEntity() => CEP(value: value);
}

extension CEPMapper on CEP {
  /// De CEP → CEPModel
  CEPModel toModel() => CEPModel(value: value);
}
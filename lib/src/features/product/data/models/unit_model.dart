import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/unit.dart';

@Entity()
class UnitModel {
  @Id()
  int id;

  @Index()
  String unitName;
  String abbreviation;

  UnitModel ({
    this.id = 0,
    required this.unitName,
    required this.abbreviation
  });
}

extension UnitModelMapper on UnitModel {
  /// De UnitModel → Unit
  Unit toEntity() => Unit(unitName: unitName, abbreviation: abbreviation);
}

extension UnitMapper on Unit {
  /// De Unit → UnitModel
  UnitModel toModel() => UnitModel(unitName: unitName, abbreviation: abbreviation);
}
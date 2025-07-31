import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/data/models/barcode_model.dart';
import 'package:sales_app/src/features/product/data/models/unit_model.dart';
import 'package:sales_app/src/features/product/domain/entities/packing.dart';

@Entity()
class PackingModel {
  @Id()
  int id;

  @Index()
  int packingId;
  String? description;
  double quantity;

  final barcode = ToOne<BarcodeModel>();
  final unit = ToOne<UnitModel>();

  PackingModel ({
    this.id = 0,
    this.packingId = 0,
    this.description,
    required this.quantity
  });
}

extension PackingModelMapper on PackingModel {
  /// De PackingModel → Packing
  Packing toEntity() {
    final packing = Packing(
      packingId: packingId,
      quantity: quantity,
      unit: unit.target!.toEntity(),
      barcode: barcode.target?.toEntity()
    );
    return packing;
  }
}

extension PackingMapper on Packing {
  /// De Packing → PackingModel
  PackingModel toModel() {
    final model = PackingModel(packingId: packingId, quantity: quantity);

    model.unit.target = unit.toModel();

    if (barcode != null) {
      model.barcode.target = barcode!.toModel();
    }

    return model;
  }
}
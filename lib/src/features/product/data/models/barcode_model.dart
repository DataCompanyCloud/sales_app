import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/domain/entities/barcode.dart';

@Entity()
class BarcodeModel {
  @Id()
  int id;

  @Index()
  String type;
  String value;

  BarcodeModel ({
    this.id = 0,
    required this.type,
    required this.value
  });
}

extension BarcodeModelMapper on BarcodeModel {
  /// De BarcodeModel → Barcode
  Barcode toEntity() => Barcode(type: type, value: value);
}

extension BarcodeMapper on Barcode {
  /// De Barcode → BarcodeModel
  BarcodeModel toModel() => BarcodeModel(type: type, value: value);
}
import 'package:sales_app/src/features/product/domain/valueObjects/barcode.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'packing.freezed.dart';
part 'packing.g.dart';

@freezed
abstract class Packing with _$Packing {
  const factory Packing({
    required int packingId,
    Barcode? barcode,
    required Unit unit,
    required double quantity,
    String? description,
  }) = _Packing;

  factory Packing.fromJson(Map<String, dynamic> json) =>
      _$PackingFromJson(json);
}

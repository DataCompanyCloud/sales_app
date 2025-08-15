import 'package:freezed_annotation/freezed_annotation.dart';

part 'barcode.freezed.dart';
part 'barcode.g.dart';

@freezed
abstract class Barcode with _$Barcode{
  const factory Barcode({
    required String type,
    required String value
  }) = _Barcode;

  factory Barcode.fromJson(Map<String, dynamic> json) => _$BarcodeFromJson(json);
}

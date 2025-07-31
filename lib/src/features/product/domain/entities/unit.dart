import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
abstract class Unit with _$Unit{
  const factory Unit({
    required String unitName,
    required String abbreviation
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}

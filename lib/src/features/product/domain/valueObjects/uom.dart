import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/category.dart';

part 'uom.freezed.dart';
part 'uom.g.dart';

@freezed
abstract class Uom with _$Uom {
  const factory Uom.raw({
    required int id,
    required String uuid,
    required String abbreviation,
    required String name,
    required Category category,
    required DateTime createAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required bool isActive,
  }) = _Uom;

  factory Uom ({
    required int id,
    required String uuid,
    required String abbreviation,
    required String name,
    required Category category,
    required DateTime createAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required bool isActive,
  }) {
    /// TODO: Validações aqui

    return Uom(
      id: id,
      uuid: uuid,
      abbreviation: abbreviation,
      name: name,
      category: category,
      createAt: createAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      isActive: isActive
    );
  }

  factory Uom.fromJson(Map<String, dynamic> json) =>
      _$UomFromJson(json);
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/attribute_value.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';

part 'attribute.freezed.dart';
part 'attribute.g.dart';

@freezed
abstract class Attribute with _$Attribute{
  const Attribute._();

  const factory Attribute({
    required int id,
    required String name,
    required List<AttributeValue> values
  }) = _Attribute;


  factory Attribute.fromJson(Map<String, dynamic> json) => _$AttributeFromJson(json);

  @JsonKey(includeFromJson: false)
  List<ImageEntity> get imagesAll => values.expand((v) => v.images).toList();
}

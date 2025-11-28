import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';

part 'attribute_value.freezed.dart';
part 'attribute_value.g.dart';

@freezed
abstract class AttributeValue with _$AttributeValue{
  const factory AttributeValue({
    required int id,
    required String value,
    @Default([]) List<ImageEntity> images,
    required Money? price,
  }) = _AttributeValue;

  factory AttributeValue.fromJson(Map<String, dynamic> json) => _$AttributeValueFromJson(json);

}

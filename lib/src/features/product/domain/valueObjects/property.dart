
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/property_value.dart';

part 'property.freezed.dart';
part 'property.g.dart';


@freezed
abstract class Property with _$Property{
  const factory Property({
    required int propertyId,
    required String name,
    required List<PropertyValue> values
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
}

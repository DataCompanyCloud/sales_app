import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/data/models/property_model.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/property_value.dart';

@Entity()
class PropertyValueModel {
  @Id()
  int id; // ID interno do ObjectBox

  @Index() // facilita upsert/lookup
  int propertyValueId; // seu ID de domínio (PropertyValue.id)

  @Index(type: IndexType.value)
  String value;

  // Dono (lado N -> 1)
  final property = ToOne<PropertyModel>();

  PropertyValueModel({
    this.id = 0,
    required this.propertyValueId,
    required this.value,
  });
}

extension PropertyValueModelMapper on PropertyValueModel {
  /// De PropertyValueModel → PropertyValue (Freezed)
  PropertyValue toEntity() => PropertyValue(
    id: propertyValueId,
    value: value,
  );
}

extension PropertyValueMapper on PropertyValue {
  /// De PropertyValue (Freezed) → PropertyValueModel (ObjectBox)
  PropertyValueModel toModel() => PropertyValueModel(
    propertyValueId: id,
    value: value,
  );
}
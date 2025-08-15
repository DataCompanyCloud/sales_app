import 'package:objectbox/objectbox.dart' hide Property ;
import 'package:sales_app/src/features/product/data/models/property_value_model.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/property.dart';

@Entity()
class PropertyModel {
  @Id()
  int id;

  @Index()
  int propertyId;

  @Index(type: IndexType.value)
  String name;

  // Uma Property possui N PropertyValues
  @Backlink('property')
  final values = ToMany<PropertyValueModel>();

  PropertyModel({
    this.id = 0,
    required this.propertyId,
    required this.name,
  });
}

extension PropertyModelMapper on PropertyModel {
  /// De PropertyModel → Property (Freezed)
  Property toEntity() => Property(
    propertyId: propertyId,
    name: name,
    values: values.map((v) => v.toEntity()).toList(),
  );
}

extension PropertyMapper on Property {
  /// De Property (Freezed) → PropertyModel (ObjectBox)
  PropertyModel toModel() {
    final model = PropertyModel(
      propertyId: propertyId,
      name: name,
    );

    // Constrói os filhos e seta o backlink
    for (final pv in values) {
      final pvModel = pv.toModel();
      pvModel.property.target = model;     // garante o vínculo N->1
      model.values.add(pvModel);           // adiciona ao ToMany
    }

    return model;
  }
}
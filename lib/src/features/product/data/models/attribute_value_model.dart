import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/data/models/attribute_model.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/attribute_value.dart';

@Entity()
class AttributeValueModel {
  @Id()
  int id; // ID interno do ObjectBox

  @Index() // facilita upsert/lookup
  int attributeValueId; // seu ID de domínio (PropertyValue.id)

  @Index(type: IndexType.value)
  String value;

  // Dono (lado N -> 1)
  final attributes = ToOne<AttributeModel>();

  AttributeValueModel({
    this.id = 0,
    required this.attributeValueId,
    required this.value,
  });
}

extension AttributeValueModelMapper on AttributeValueModel {
  /// De AttributeValueModel → AttributeValue (Freezed)
  AttributeValue toEntity() => AttributeValue(
    id: attributeValueId,
    value: value,
  );
}

extension AttributeValueMapper on AttributeValue {
  /// De AttributeValue (Freezed) → AttributeValueModel (ObjectBox)
  AttributeValueModel toModel() => AttributeValueModel(
    attributeValueId: id,
    value: value,
  );
}
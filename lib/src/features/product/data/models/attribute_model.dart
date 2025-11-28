import 'package:objectbox/objectbox.dart' hide Property ;
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/product/data/models/attribute_value_model.dart';
import 'package:sales_app/src/features/product/data/models/image_model.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/attribute.dart';

@Entity()
class AttributeModel {
  @Id()
  int id;

  @Index()
  int attributeId;

  @Index(type: IndexType.value)
  String name;

  // Um Attribute possui N AttributesValues
  @Backlink('attributes')
  final values = ToMany<AttributeValueModel>();

  AttributeModel({
    this.id = 0,
    required this.attributeId,
    required this.name,
  });
}

extension AttributeModelMapper on AttributeModel {
  /// De AttributeModel → Attribute (Freezed)
  Attribute toEntity() => Attribute(
    id: attributeId,
    name: name,
    values: values.map((v) => v.toEntity()).toList(),
  );

  void deleteRecursively({
    required Box<AttributeModel> attributeBox,
    required Box<AttributeValueModel> attributeValueBox,
    required Box<MoneyModel> moneyBox,
    required Box<ImageModel> imageBox,
  }) {

    for (final value in values) {
      value.deleteRecursively(moneyBox: moneyBox, imageBox: imageBox, attributeValueBox: attributeValueBox);
    }

    attributeBox.remove(id);
  }
}

extension AttributeMapper on Attribute {
  /// De Attribute (Freezed) → AttributeModel (ObjectBox)
  AttributeModel toModel() {
    final model = AttributeModel(
      attributeId: id,
      name: name,
    );

    // Constrói os filhos e seta o backlink
    for (final pv in values) {
      final pvModel = pv.toModel();
      pvModel.attributes.target = model;   // garante o vínculo N->1
      model.values.add(pvModel);           // adiciona ao ToMany
    }

    return model;
  }
}
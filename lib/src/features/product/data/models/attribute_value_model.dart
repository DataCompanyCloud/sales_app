import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/money_model.dart';
import 'package:sales_app/src/features/product/data/models/attribute_model.dart';
import 'package:sales_app/src/features/product/data/models/image_model.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/attribute_value.dart';

@Entity()
class AttributeValueModel {
  @Id()
  int id; // ID interno do ObjectBox

  @Index() // facilita upsert/lookup
  int attributeValueId; // seu ID de domínio (PropertyValue.id)

  @Index(type: IndexType.value)
  String value;

  final images = ToMany<ImageModel>();
  final price = ToOne<MoneyModel>();

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
  AttributeValue toEntity() {
    final imagesList = images.map((i) => i.toEntity()).toList();
    return AttributeValue(
      id: attributeValueId,
      value: value,
      price: price.target?.toEntity(),
      images: imagesList
    );
  }

  /// Remove este CustomerModel e todas as entidades relacionadas.
  void deleteRecursively({
    required Box<MoneyModel> moneyBox,
    required Box<ImageModel> imageBox,
    required Box<AttributeValueModel> attributeValueBox,
  }) {
    if (price.target != null) {
      moneyBox.remove(price.targetId);
    }

    for (final image in images) {
      imageBox.remove(image.id);
    }

    attributeValueBox.remove(id);
  }
}

extension AttributeValueMapper on AttributeValue {
  /// De AttributeValue (Freezed) → AttributeValueModel (ObjectBox)
  AttributeValueModel toModel() {
    final model = AttributeValueModel(
      attributeValueId: id,
      value: value,
    );

    model.price.target = price?.toModel();

    if (images.isNotEmpty) {
      model.images.addAll(images.map((i) => i.toModel()));
    }

    return model;
  }
}
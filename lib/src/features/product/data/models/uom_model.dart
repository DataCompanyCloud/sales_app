import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/data/models/category_model.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/uom.dart';

@Entity()
class UomModel {
  @Id(assignable: true)
  int id;

  String uuid;
  String abbreviation;
  String name;
  DateTime createAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  bool isActive;

  final categories = ToOne<CategoryModel>();

  UomModel ({
    this.id = 0,
    required this.uuid,
    required this.abbreviation,
    required this.name,
    required this.createAt,
    this.updatedAt,
    this.deletedAt,
    required this.isActive
  });
}

extension UomModelMapper on UomModel {
  Uom toEntity() {
    final categoriesList = categories.target!.toEntity();

    return Uom(
      id: id,
      uuid: uuid,
      abbreviation: abbreviation,
      name: name,
      category: categoriesList,
      createAt: createAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      isActive: isActive
    );
  }

  void deleteRecursively({
    required Box<CategoryModel> categoryBox,
  }) {
    if (categories.target != null) {
      categoryBox.remove(categories.targetId);
    }
  }
}

extension UomMapper on Uom {
  UomModel toModel() {
    final entity = UomModel(
      id: id,
      uuid: uuid,
      abbreviation: abbreviation,
      name: name,
      createAt: createAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      isActive: isActive
    );

    entity.categories.target = category.toModel();

    return entity;
  }
}
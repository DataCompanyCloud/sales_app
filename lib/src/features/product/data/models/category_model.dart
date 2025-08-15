import 'package:objectbox/objectbox.dart';

// Resolver esse import futuramente
import 'package:sales_app/src/features/product/domain/valueObjects/category.dart' as entity;

@Entity()
class CategoryModel {
  @Id()
  int id;

  @Index()
  int categoryId;
  String name;

  CategoryModel ({
    this.id = 0,
    this.categoryId = 0,
    required this.name
  });
}

extension CategoryModelMapper on CategoryModel {
  /// De CategoryModel → Category
  entity.Category toEntity() => entity.Category(categoryId: categoryId, name: name);
}

extension CategoryMapper on entity.Category {
  /// De Category → CategoryModel
  CategoryModel toModel() => CategoryModel(categoryId: categoryId, name: name);
}
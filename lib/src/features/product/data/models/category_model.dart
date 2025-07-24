import 'package:objectbox/objectbox.dart';

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
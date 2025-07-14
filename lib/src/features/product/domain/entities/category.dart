class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name
  }) {

    if (id <= 0) {
      throw ArgumentError('Category: "id" cannot be negative.');
    }
    if (name.trim().isEmpty) {
      throw ArgumentError('Category: "name" cannot be null.');
    }
    if (name.trim().length < 3) {
      throw ArgumentError('Category: "name" must have at least three characters.');
    }
  }
}
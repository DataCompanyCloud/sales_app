class Unit {
  final String name;
  final String abbreviation;

  Unit({
    required this.name,
    required this.abbreviation
  }){

    if (name.trim().isEmpty) {
      throw ArgumentError('Unit: "name" cannot be null.');
    }
    if (name.trim().length < 3) {
      throw ArgumentError('Unit: "name" must have at least three characters.');
    }
    if (abbreviation.trim().isEmpty) {
      throw ArgumentError('Unit: "abbreviation" cannot be null.');
    }
    if (!RegExp(r'^[a-zA-Z]{1,5}$').hasMatch(abbreviation)) {
      throw ArgumentError('Unit: "abbreviation" must contain only letters (1 - 5).');
    }
  }
}
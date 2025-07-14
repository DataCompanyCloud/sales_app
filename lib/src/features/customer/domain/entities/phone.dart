class Phone {
  final String value;

  Phone({
    required this.value
  }) {

    if (value.trim().isEmpty) {
      throw ArgumentError('Phone: "number" cannot be empty.');
    }

    final phoneRegex = RegExp(r'^(\(\d{3}\)\s?\d{3}-\d{4}|\d{3}-\d{3}-\d{4}|\d{3}\.\d{3}\.\d{4}|\d{10})$');
    if (!phoneRegex.hasMatch(value)) {
      throw ArgumentError('Phone: "number" must be a valid phone number.');
    }
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Phone && runtimeType == other.runtimeType && value == other.value;

  // verifica se os números de telefone são repetidos
  @override
  int get hashCode => value.hashCode;
}
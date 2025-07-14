class Email {
  final String value;

  Email({
    required this.value
  }) {

    if (value.trim().isEmpty) {
      throw ArgumentError('Email: "value" cannot be empty.');
    }

    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
        r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
        r"(?:\.[a-zA-Z]{2,})+$"
    );
    if (!emailRegex.hasMatch(value)) {
      throw ArgumentError('Email: "value" must be a valid email.');
    }
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Email && runtimeType == other.runtimeType && value == other.value;

  // verifica se os emails são repetidos
  @override
  int get hashCode => value.hashCode;
}
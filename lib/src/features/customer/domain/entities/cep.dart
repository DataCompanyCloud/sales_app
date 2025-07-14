class CEP {
  final String value;

  CEP(String? cep) : value = _cleanAndValidate(cep ?? '') {
    if (cep == null) {
      throw ArgumentError('CEP não pode ser nulo.');
    }
  }

  static String _cleanAndValidate(String? cep) {
    // desformata
    final numericOnly = cep?.replaceAll(RegExp(r'\D'), '') ?? '';

    if (numericOnly.length != 8) {
      throw ArgumentError('CEP inválido.');
    }

    return numericOnly;
  }

  String get formatted {
    final digits = value.padLeft(8, '0');
    return '${digits.substring(0, 5)}-${digits.substring(5, 8)}';
  }

  @override
  String toString() => formatted;
}
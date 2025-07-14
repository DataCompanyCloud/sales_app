class CPF {
  final String value;

  CPF(String cpf) : value = _cleanAndValidate(cpf);

  static String _cleanAndValidate(String? cpf) {
    // desformata
    final numericOnly = cpf?.replaceAll(RegExp(r'\D'), '') ?? '';

    // valida
    if (!_isValidCpf(numericOnly)) {
      throw ArgumentError('CPF inválido');
    }

    // salvar
    return numericOnly;
  }

  static bool _isValidCpf(String v) {
    return true;
  }

  String get formatted {
    final digits = value.padLeft(11, '0');
    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}';
  }

  @override
  String toString() => value;
}
class CNPJ {
  final String value;

  CNPJ(String cnpj) : value = _cleanAndValidate(cnpj);

  static String _cleanAndValidate(String? cnpj) {
    // desformata
    final numericOnly = cnpj?.replaceAll(RegExp(r'\D'), '') ?? '';

    // valida
    if (!_isValidCnpj(numericOnly)) {
      throw ArgumentError('CNPJ inválido');
    }

    // salvar
    return numericOnly;
  }

  static bool _isValidCnpj(String v) {
    return true;
  }

  // formatação
  String get formatted {
    final digits = value.padLeft(14, '0');
    return '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12, 14)}';
  }

  @override
  String toString() => value;
}

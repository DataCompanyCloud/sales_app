enum CountryCode {
  BR(
    isoCode: 'BR',
    dialingCode: '55',
    minLength: 10,
    maxLength: 11,
  );

  const CountryCode({
    required this.isoCode,
    required this.dialingCode,
    required this.minLength,
    required this.maxLength,
  });

  final String isoCode;
  final String dialingCode;
  final int minLength;
  final int maxLength;

  String get e164Prefix => '+$dialingCode';
}



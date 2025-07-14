import 'package:faker/faker.dart';

String generateCpf({bool formatted = true}) {
  final fakerGen = faker.randomGenerator;
  final baseNumbers = List<int>.generate(9, (_) => fakerGen.integer(10));

  int d1 = 0;
  for (int i = 0; i < 9; i++) {
    d1 += baseNumbers[i] * (10 - i);
  }
  d1 = (d1 * 10) % 11;
  if (d1 == 10) d1 = 0;

  int d2 = 0;
  for (int i = 0; i < 9; i++) {
    d2 += baseNumbers[i] * (11 - i);
  }
  d2 += d1 * 2;
  d2 = (d2 * 10) % 11;
  if (d2 == 10) d2 = 0;

  final digits = [...baseNumbers, d1, d2];
  final numbers = digits.join();

  if (!formatted) return numbers;

  return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
}

String generateCnpj({bool formatted = true}) {
  final fakerGen = faker.randomGenerator;
  final base = List<int>.generate(8, (_) => fakerGen.integer(10))
    ..addAll([0, 0, 0, 1]);

  const weight1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  const weight2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  int calcDigit(List<int> numbers, List<int> weights) {
    final sum = List.generate(weights.length, (i) => numbers[i] * weights[i])
        .reduce((a, b) => a + b);
    final mod = sum % 11;
    return mod < 2 ? 0 : 11 - mod;
  }

  final d1 = calcDigit(base, weight1);
  final d2 = calcDigit([...base, d1], weight2);

  final digits = [...base, d1, d2];
  final numbers = digits.join();

  if (!formatted) return numbers;

  return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12)}';
}

String generateCep ({bool formatted = true}) {
  final fakerGen = faker.randomGenerator;
  final digits = List.generate(8, (_) => fakerGen.integer(10)).join();

  if (!formatted) return digits;

  return '${digits.substring(0, 5)}-${digits.substring(5, 8)}';
}
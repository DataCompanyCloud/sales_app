import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';

part 'money.freezed.dart';
part 'money.g.dart';

@freezed
abstract class Money with _$Money {
  const Money._();

  const factory Money.raw({
    required int amount,
    @Default("BRL") String currency,
    @Default(2) int scale,
  }) = _Money;

  /// amount = valor inteiro na menor unidade da moeda
  /// scale = casas decimais (ex.: 2 → centavos, 3 → milésimos, 8 → satoshis de crypto)
  factory Money({
    required int amount,
    String currency = 'BRL',
    int scale = 2,
  }) {
    // ---- validações ----
    if (amount < 0) {
      throw AppException.errorUnexpected(
        'Amount não pode ser negativo: $amount',
      );
    }

    // 0 é válido (ex.: JPY), e limite superior opcional (ex.: 8 para crypto)
    if (scale < 0 || scale > 8) {
      throw AppException.errorUnexpected(
        'Scale deve estar entre 0 e 8. Valor: $scale',
      );
    }


    return Money.raw(amount: amount, currency: currency, scale: scale);
  }

  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);

  double get decimalValue => amount / pow(10, scale);

  String format({String? locale}) => decimalValue.toString();

  Money operator +(Money other) {
    _assertSameCurrency(other);
    final (a1, a2, s) = _alignScales(this, other);
    return Money(amount: a1 + a2, currency: currency, scale: s);
  }

  Money operator -(Money other) {
    _assertSameCurrency(other);
    final (a1, a2, s) = _alignScales(this, other);
    return Money(amount: a1 - a2, currency: currency, scale: s);
  }

  Money operator / (Money other) {
    _assertSameCurrency(other);
    final (a1, a2, s) = _alignScales(this, other);
    return Money(amount: a1 - a2, currency: currency, scale: s);
  }

  Money multiply(num factor) =>
      Money(amount: (amount * factor).round(), currency: currency, scale: scale);

  double ratioTo(Money other) {
    if (currency != other.currency) {
      throw ArgumentError("Moedas diferentes: $currency vs ${other.currency}");
    }

    final s = scale > other.scale ? scale : other.scale;
    final a1 = amount * pow(10, s - scale);
    final a2 = other.amount * pow(10, s - other.scale);

    if (a2 == 0) return 0;
    return a1 / a2;
  }

  Money divide(num divisor) {
    if (divisor == 0) {
      throw ArgumentError("Divisor não pode ser zero");
    }
    final newAmount = (amount / divisor).round();
    return Money(amount: newAmount, currency: currency, scale: scale);
  }

  void _assertSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Currencies must match ($currency != ${other.currency})');
    }
  }

  /// Alinha escalas para somar/subtrair com segurança.
  /// Usa a maior escala entre os dois valores.
  static (int a1, int a2, int s) _alignScales(Money m1, Money m2) {
    final s = max(m1.scale, m2.scale);
    final f1 = pow(10, s - m1.scale).toInt();
    final f2 = pow(10, s - m2.scale).toInt();
    return (m1.amount * f1, m2.amount * f2, s);
  }

}

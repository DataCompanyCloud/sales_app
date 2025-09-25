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
      throw AppException.errorUnexpected('Scale deve estar entre 0 e 8. Valor: $scale');
    }

    return Money.raw(amount: amount, currency: currency, scale: scale);
  }

  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);

  double get decimalValue => amount / pow(10, scale);

  String format({String? locale}) => decimalValue.toStringAsFixed(scale);

  /// Gera uma entidade Money(amount: 0), scale e currency pode ser adaptados;
  static Money zero({String currency = 'BRL', int scale = 2}) => Money(amount: 0, currency: currency, scale: scale);

  // --- operações ---
  Money plus(Money other) {
    if (currency != other.currency) {
      throw AppException.errorUnexpected('Dinheiro incompatível: $currency vs ${other.currency}');
    }

    if (this.scale == other.scale) {
      return Money(amount: amount + other.amount, currency: currency, scale: this.scale);
    }

    final (amount1, amount2, scale) = _alignScales(this, other);
    return Money.raw(amount: amount1 + amount2, currency: currency, scale: scale);
  }

  Money minus(Money other) {
    if (currency != other.currency) {
      throw AppException.errorUnexpected('Dinheiro incompatível: $currency vs ${other.currency}');
    }

    if (this.scale == other.scale) {
      return Money(amount: amount + other.amount, currency: currency, scale: this.scale);
    }

    final (amount1, amount2, scale) = _alignScales(this, other);
    return Money.raw(amount: amount1 - amount2, currency: currency, scale: scale);
  }

  Money multiply(num qty) {
    final result = (amount * qty).round();
    return Money.raw(amount: result, currency: currency, scale: scale);
  }

  Money divide(Money other) {
    throw UnimplementedError();
  }

  double toDouble() => amount / _pow10(scale);

  int _pow10(int n) {
    var p = 1;
    for (var i = 0; i < n; i++) {
      p *= 10;
    }
    return p;
  }

  /// Alinha escalas para somar/subtrair com segurança.
  /// Usa a maior escala entre os dois valores.
  (int amount1, int amount2, int scale) _alignScales(Money m1, Money m2) {
    final s = max(m1.scale, m2.scale);
    final f1 = pow(10, s - m1.scale).toInt();
    final f2 = pow(10, s - m2.scale).toInt();
    return (m1.amount * f1, m2.amount * f2, s);
  }

  double ratioTo(Money other) {
    if (currency != other.currency) {
      throw AppException.errorUnexpected('Dinheiro incompatível: $currency vs ${other.currency}');
    }

    final s = scale > other.scale ? scale : other.scale;
    final a1 = amount * pow(10, s - scale);
    final a2 = other.amount * pow(10, s - other.scale);
    if (a2 == 0) return 0;
    return a1 / a2;
  }

}

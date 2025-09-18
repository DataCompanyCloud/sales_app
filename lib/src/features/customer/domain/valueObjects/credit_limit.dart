

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';

part 'credit_limit.freezed.dart';
part 'credit_limit.g.dart';

@freezed
abstract class CreditLimit with _$CreditLimit {
  const CreditLimit._();

  const factory CreditLimit.raw({
    required Money maximum,
    required Money available,
  }) = _CreditLimit;

  factory CreditLimit ({
    required Money maximum,
    required Money available,
  }) {
    if (maximum.amount < 0) {
      throw AppException.errorUnexpected("O limite não pode ser negativo");
    }

    if (available.amount < 0) {
      throw AppException.errorUnexpected("O limite nao pode ser negativo");
    }

    if (maximum.currency != available.currency) {
      throw AppException.errorUnexpected('Moedas devem ser iguais');
    }

    if (available.amount  > maximum.amount) {
      throw AppException.errorUnexpected("O valor do limite atual nao pode ser maior que o proprio limite total");
    }

    return CreditLimit.raw(maximum: maximum, available: available);
  }

  factory CreditLimit.fromJson(Map<String, dynamic> json) => _$CreditLimitFromJson(json);

  /// Debita do disponível. Mantém invariantes.
  CreditLimit spend(Money value) {
    if (maximum.currency != available.currency) {
      throw AppException.errorUnexpected('Moedas devem ser iguais');
    }

    final nextAvailable = available.minus(maximum);

    if (nextAvailable.amount < 0) {
      throw AppException.errorUnexpected('Limite insuficiente');
    }

    return copyWith(available: nextAvailable);
  }
}

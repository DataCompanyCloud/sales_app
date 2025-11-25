import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';

part 'percentage.freezed.dart';
part 'percentage.g.dart';


@freezed
abstract class Percentage with _$Percentage {
  const Percentage._();

  const factory Percentage.raw({
    required double value, // sempre em 0-100
  }) = _Percentage;


  factory Percentage({
    required double value,
  }) {
    // ---- validações ----
    if (value < 0) {
      throw Exception("Percentual inválido: $value");
    }

    return Percentage.raw(value: value);
  }

  factory Percentage.fromJson(Map<String, dynamic> json) => _$PercentageFromJson(json);

  factory Percentage.fromString(double json) => Percentage(value: json);

  /// Converte 18 → 0.18
  double toFactor() => value / 100;

  /// Multiplica um Money com este percentual
  Money apply(Money money) {
    return money.multiply(toFactor());
  }

  // /// Apenas formatação
  String format() => "${value.toStringAsFixed(2)}%";

  @override
  String toString() => format();
}



class PercentageConverter extends JsonConverter<Percentage, num> {
  const PercentageConverter();

  @override
  Percentage fromJson(num json) => Percentage.fromString(json.toDouble());

  @override
  double toJson(Percentage object) => object.value;
}

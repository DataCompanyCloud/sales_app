import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum OrderStatus {
  @JsonValue('draft')
  draft, // Rascunho
  @JsonValue('confirmed')
  confirmed, // Finalizado
  @JsonValue('cancelled')
  cancelled, // Cancelado
}
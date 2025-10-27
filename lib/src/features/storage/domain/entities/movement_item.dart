import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement_item.freezed.dart';
part 'movement_item.g.dart';

@freezed
abstract class MovementItem with _$MovementItem {
  const MovementItem._();

  const factory MovementItem.raw({
    required int id,              // id local
    required String code, // Sinc com o servidor
    int? serverId,
    int? movementId,
    required int productId,
    required String productCode,
    required String productName,
    required int quantity,
  }) = _MovementItem;

  factory MovementItem ({
    required int id,
    required String code,
    int? serverId,
    int? movementId,
    required int productId,
    required String productCode,
    required String productName,
    required int quantity
  }) {
    /// TODO: Fazer as validações quando as informações forem diferentes de null!

    return MovementItem.raw(
      id: id,
      code: code,
      productId: productId,
      productCode: productCode,
      productName: productName,
      quantity: quantity
    );
  }

  factory MovementItem.fromJson(Map<String, dynamic> json) =>
      _$MovementItemFromJson(json);
}

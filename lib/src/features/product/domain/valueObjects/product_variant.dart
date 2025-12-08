//
//
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
//
// part 'product_variant.freezed.dart';
// part 'product_variant.g.dart';
//
// @freezed
// abstract class ProductVariant with _$ProductVariant {
//   const ProductVariant._();
//
//   const factory ProductVariant({
//     required int id,
//     required int productId,
//
//     /// Mapa attributeId -> attributeValueId
//     required Map<int, int> attributes,
//
//     /// Se preenchido, é o preço final desse SKU
//     required Money? priceOverride,
//
//     /// Opcional: delta apenas dessa combinação (em cima do base + deltas simples)
//     required Money? priceDelta,
//   }) = _ProductVariant;
// }

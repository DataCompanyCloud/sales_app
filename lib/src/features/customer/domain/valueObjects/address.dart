import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String? state,
    required String? city,
    required String? street,
    // Bairro String
    // Número int?
    required CEP? cep
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const Address._();

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

  String get formatted {
    final parts = <String>[];

    if (street != null && street!.trim().isNotEmpty) {
      parts.add(street!.trim());
    }

    if (city != null && city!.trim().isNotEmpty) {
      parts.add(city!.trim());
    }

    if (state != null && state!.trim().isNotEmpty) {
      parts.add(state!.trim());
    }

    if (cep != null) {
      // Ajusta conforme sua classe CEP (value, formatted, etc)
      parts.add(cep!.value.trim());
    }

    return parts.isEmpty ? '-' : parts.join(', ');
  }

}

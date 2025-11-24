import 'package:sales_app/src/features/customer/domain/valueObjects/address_type.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const Address._();

  const factory Address({
    //required String country, // país
    required BrazilianState state,
    required String city,
    required String street,
    required String district, // bairro
    int? number,              // número
    CEP? cep,
    required AddressType type,
    required bool isPrimary
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);


  /// Ex.: "Rua X, 123 - Bairro Y, Cidade - UF, 12345-678"
  String get formatted {
    final buffer = StringBuffer();

    buffer.write(street);

    if (number != null) {
      buffer.write(', $number');
    }

    buffer.write(' - $district');
    buffer.write(', $city - $state');

    if (cep != null) {
      buffer.write(', ${cep!.value}');
    }


    return buffer.toString();
  }

}

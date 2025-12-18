import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address_type.dart';
import 'package:sales_app/src/features/company/domain/valueObjects/brazilian_state.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const Address._();

  const factory Address.raw({
    required BrazilianState state,
    required String city,
    required String street,
    required String district, // bairro
    int? number,              // número
    @CEPConverter() CEP? cep,
    required AddressType type,
    required bool isPrimary
  }) = _Address;

  factory Address({
    required BrazilianState state,
    required String city,
    required String street,
    required String district, // bairro
    int? number,              // número
    @CEPConverter() CEP? cep,
    required AddressType type,
    required bool isPrimary
  }){
    if (city.isEmpty) {
      throw AppException(AppExceptionCode.CODE_015_CITY_REQUIRED, "Cidade é obrigatória");
    }

    if (street.isEmpty) {
      throw AppException(AppExceptionCode.CODE_017_STREET_REQUIRED, "Logradouro é obrigatório");
    }

    if (district.isEmpty) {
      throw AppException(AppExceptionCode.CODE_018_DISTRICT_REQUIRED, "Bairro é obrigatório");
    }

    return Address.raw(
      state: state,
      city: city,
      street: street,
      district: district,
      type: type,
      number: number,
      cep: cep,
      isPrimary: isPrimary
    );
  }




  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);


  /// Ex.: "Rua X, 123 - Bairro Y, Cidade - UF, 12345-678"
  String get formatted {
    final buffer = StringBuffer();

    buffer.write(street);

    buffer.write(', ${number ?? "S/N"}');

    buffer.write(' - $district');
    buffer.write(', $city');

    if (uf != null) {
      buffer.write(' - $uf');
    }

    if (cep != null) {
      buffer.write(', ${cep!.formatted}');
    }


    return buffer.toString();
  }

  String? get uf => state?.name;
  String? get ufName => state?.fullName;
}

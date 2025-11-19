import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address_type.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';

@Entity()
class AddressModel {
  @Id()
  int id;

  String state;
  String city;
  String street;
  String? cep;
  int type;
  String district;
  int? number;
  bool isPrimary;

  AddressModel({
    this.id = 0,
    required this.state,
    required this.city,
    required this.street,
    required this.cep,
    required this.district,
    required this.type,
    required this.isPrimary,
    this.number
  });
}

extension AddressModelMapper on AddressModel {
  /// De AddressModel → Address
  Address toEntity() {
    final address = Address(
      state: state,
      city: city,
      street: street,
      district: district,
      number: number,
      type: AddressType.values[type],
      cep: cep != null ? CEP(value: cep!) : null,
      isPrimary: isPrimary
    );
    return address;
  }
}

extension AddressMapper on Address {
  /// De Address → AddressModel
  AddressModel toModel() {
    final model = AddressModel(
      city: city,
      state: state,
      street: street,
      district: district,
      number: number,
      type: type.index,
      cep: cep?.value,
      isPrimary: isPrimary
    );
    return model;
  }
}
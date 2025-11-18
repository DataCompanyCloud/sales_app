import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/cep.dart';

@Entity()
class AddressModel {
  @Id()
  int id;

  String? state;
  String? city;
  String? street;
  String? cep;

  AddressModel({
    this.id = 0,
    this.state,
    this.city,
    this.street,
    this.cep
  });
}

extension AddressModelMapper on AddressModel {
  /// De AddressModel → Address
  Address toEntity() {
    final address = Address(
      state: state,
      city: city,
      street: street,
      cep: cep != null ? CEP(value: cep!) : null
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
      cep: cep?.value
    );
    return model;
  }
}
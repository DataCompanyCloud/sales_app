import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/cep_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';

@Entity()
class AddressModel {
  @Id()
  int id;

  String? state;
  String? city;
  String? street;

  final cep = ToOne<CEPModel>();

  AddressModel({
    this.id = 0,
    this.state,
    this.city,
    this.street,
  });
}

extension AddressModelMapper on AddressModel {
  /// De AddressModel → Address
  Address toEntity() {
    final address = Address(
      state: state,
      city: city,
      street: street,
      cep: cep.target?.toEntity()
    );
    return address;
  }
}

extension AddressMapper on Address {
  /// De Address → AddressModel
  AddressModel toModel() {
    final model = AddressModel(city: city, state: state, street: street);

    if (cep != null) {
      model.cep.target = cep!.toModel();
    }

    return model;
  }
}
import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/country_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone_type.dart';

@Entity()
class PhoneModel {
  @Id()
  int id;

  String value;
  int type;
  int countryCode;

  PhoneModel ({
    this.id = 0,
    required this.value,
    required this.type,
    required this.countryCode
  });
}

extension PhoneModelMapper on PhoneModel {
  /// De PhoneModel → Phone
  Phone toEntity() => Phone.raw(
    value: value,
    type: PhoneType.values[type],
    countryCode: CountryCode.values[countryCode]
  );
}

extension PhoneMapper on Phone {
  /// De Phone → PhoneModel
  PhoneModel toModel() => PhoneModel(
    value: value,
    type: type.index,
    countryCode: countryCode.index
  );
}
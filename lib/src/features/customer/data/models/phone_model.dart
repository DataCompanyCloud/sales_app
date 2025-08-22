import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';

@Entity()
class PhoneModel {
  @Id()
  int id;

  String value;
  int type;

  PhoneModel ({
    this.id = 0,
    required this.value,
    required this.type
  });
}

extension PhoneModelMapper on PhoneModel {
  /// De PhoneModel → Phone
  Phone toEntity() => Phone(value: value, type: PhoneType.values[type]);
}

extension PhoneMapper on Phone {
  /// De Phone → PhoneModel
  PhoneModel toModel() => PhoneModel(value: value, type: type.index);
}
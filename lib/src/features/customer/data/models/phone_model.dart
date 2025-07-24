import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/entities/phone.dart';

@Entity()
class PhoneModel {
  @Id()
  int id;

  @Unique()
  String value;

  PhoneModel ({
    this.id = 0,
    required this.value
  });
}

extension PhoneModelMapper on PhoneModel {
  /// De PhoneModel → Phone
  Phone toEntity() => Phone(value: value);
}

extension PhoneMapper on Phone {
  /// De Phone → PhoneModel
  PhoneModel toModel() => PhoneModel(value: value);
}
import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';

@Entity()
class ContactInfoModel {
  @Id()
  int id;

  final String name;
  final bool isPrimary;

  final String? email;
  final phone = ToOne<PhoneModel>();

  ContactInfoModel ({
    this.id = 0,
    required this.name,
    required this.isPrimary,
    required this.email
  });
}

extension ContactInfoModelMapper on ContactInfoModel {
  /// De ContactInfoModel → ContactInfo
  ContactInfo toEntity() => ContactInfo.raw(
    name: name,
    isPrimary: isPrimary,
    phone: phone.target?.toEntity(),
    email: email != null ? Email(value: email!) : null
  );

  void deleteRecursively({
    required Box<ContactInfoModel> contactInfoBox,
    required Box<PhoneModel> phoneBox,
  }) {

    if (phone.target != null) {
      phoneBox.remove(phone.targetId);
    }

    contactInfoBox.remove(id);
  }
}

extension ContactInfoMapper on ContactInfo {
  /// De ContactInfo → ContactInfoModel
  ContactInfoModel toModel() {

    final model = ContactInfoModel(
      name: name,
      isPrimary: isPrimary,
      email: email?.value
    );

    if (phone != null) {
      model.phone.target = phone!.toModel();
    }
    return model;
  }
}

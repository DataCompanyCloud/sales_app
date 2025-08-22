import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/data/models/email_model.dart';
import 'package:sales_app/src/features/customer/data/models/phone_model.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';

@Entity()
class ContactInfoModel {
  @Id()
  int id;

  final String name;
  final bool isPrimary;

  final email = ToOne<EmailModel>();
  final phone = ToOne<PhoneModel>();

  ContactInfoModel ({
    this.id = 0,
    required this.name,
    required this.isPrimary
  });
}

extension ContactInfoModelMapper on ContactInfoModel {
  /// De ContactInfoModel → ContactInfo
  ContactInfo toEntity() => ContactInfo(
    name: name,
    isPrimary: isPrimary,
    phone: phone.target?.toEntity(),
    email: email.target?.toEntity()
  );
}

extension ContactInfoMapper on ContactInfo {
  /// De ContactInfo → ContactInfoModel
  ContactInfoModel toModel() {

    final model = ContactInfoModel(
      name: name,
      isPrimary: isPrimary,
    );

    if (phone != null) {
      model.phone.target = phone!.toModel();
    }

    if (email != null) {
      model.email.target = email!.toModel();
    }
    return model;
  }
}

import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/customer/domain/entities/email.dart';

@Entity()
class EmailModel {
  @Id()
  int id;

  @Unique()
  String value;

  EmailModel ({
    this.id = 0,
    required this.value
  });
}

extension EmailModelMapper on EmailModel {
  /// De EmailModel → Email
  Email toEntity() => Email(value: value);
}

extension EmailMapper on Email {
  /// De Email → EmailModel
  EmailModel toModel() => EmailModel(value: value);
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/email.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/phone.dart';

part 'contact_info.freezed.dart';
part 'contact_info.g.dart';

@freezed
abstract class ContactInfo with _$ContactInfo {
  const ContactInfo._();

  const factory ContactInfo.raw({
    required String name,
    Email? email,
    Phone? phone,
    @Default(false) bool isPrimary,
  }) = _ContactInfo;


  factory ContactInfo({
    required String name,
    Email? email,
    Phone? phone,
    bool isPrimary = false,
  }) {

    if (isPrimary && email == null) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "O Contado principal precisa obrigatóriamente ter um email");
    }

    if (isPrimary && phone == null) {
      throw AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, "O Contado principal precisa obrigatóriamente ter um telefone");
    }

    return ContactInfo.raw(name: name, email: email, phone: phone, isPrimary: isPrimary);
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
}

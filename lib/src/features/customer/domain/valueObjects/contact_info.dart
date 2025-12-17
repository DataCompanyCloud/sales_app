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
    @EmailConverter() Email? email,
    Phone? phone,
    @Default(false) bool isPrimary,
  }) = _ContactInfo;

  factory ContactInfo({
    required String name,
    @EmailConverter() Email? email,
    Phone? phone,
    bool isPrimary = false,
  }) {

    if (name.trim().isEmpty) {
      throw AppException(AppExceptionCode.CODE_025_CONTACT_NAME_REQUIRED, 'Nome do contato é obrigatório.');
    }

    if (name.length < 2) {
      throw AppException(AppExceptionCode.CODE_027_NAME_INVALID, 'Nome do contato inválido.');
    }

    if (email == null && phone == null) {
      throw AppException(AppExceptionCode.CODE_026_CONTACT_EMPTY, 'Informe ao menos um meio de contato.');
    }

    return ContactInfo.raw(
      name: name,
      email: email,
      phone: phone,
      isPrimary: isPrimary
    );
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
    _$ContactInfoFromJson(json);
}

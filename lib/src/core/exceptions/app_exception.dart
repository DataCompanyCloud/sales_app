import 'package:sales_app/src/core/exceptions/app_exception_code.dart';

class AppException implements Exception {
  static const prefix = 'CODE_';

  final String message;
  final AppExceptionCode code;

  const AppException(this.code, this.message);

  String formatCode() {
    // Remove o prefixo "CODE_" do nome do enum
    return code.name.replaceFirst(prefix, '');
  }

  @override
  String toString() => '[${formatCode()}] $message';


  static AppException errorUnexpected(String message) {
    return AppException(AppExceptionCode.CODE_000_ERROR_UNEXPECTED, message);
  }
}
import 'package:dio/dio.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<User> login(String login, String password) async {
    try {
      final json = await apiClient.post<Map<String, dynamic>>(ApiEndpoints.login, data: {
        'login': login,
        'password': password,
      });

      return User.fromJson(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) {
        throw AppException(AppExceptionCode.CODE_007_AUTH_INVALID_CREDENTIALS, "Credênciais inválidas");
      }

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_014_USER_NOT_FOUND, "Usuário não existe");
      }

      throw AppException(AppExceptionCode.CODE_012_AUTH_NETWORK_ERROR, "Falha ao fazer login");
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }

  final LocalAuthentication auth = LocalAuthentication();
  Future<bool> authenticateWithBiometrics() async {
    try {
      final isAvaliable = await auth.canCheckBiometrics;
      if (!isAvaliable) return false;

      final didAuthenticate = await auth.authenticate(
        localizedReason: "Por favor, autentique-se com sua digital",
        options: const AuthenticationOptions(
          biometricOnly: true,
        )
      );

      return didAuthenticate;
    } catch (e) {
      print('Erro na autenticação: $e');
      return false;
    }
  }
}
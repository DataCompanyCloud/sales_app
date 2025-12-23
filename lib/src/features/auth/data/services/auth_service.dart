import 'package:dio/dio.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';
import 'package:sales_app/src/features/company/domain/entities/company_group.dart';
import 'package:sales_app/src/features/company/domain/repositories/company_group_repository.dart';

class AuthService {
  final ApiClient apiClient;
  final CompanyGroupRepository companyGroupRepository;

  AuthService(this.apiClient, this.companyGroupRepository);

  Future<User> login(String login, String password) async {
    try {
      final json = await apiClient.post<Map<String, dynamic>>(ApiEndpoints.login, data: {
        'login': login,
        'password': password,
      });

      final userJson = json['user'] as Map<String, dynamic>;
      final groupsJson = json['groups'] as List<dynamic>;

      final user = User.fromJson(userJson);
      final groups = groupsJson
        .map((e) => CompanyGroup.fromJson(e as Map<String, dynamic>))
        .toList();

      await companyGroupRepository.saveAll(groups);

      return user;
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
      final isAvailable = await auth.canCheckBiometrics;
      if (!isAvailable) return false;

      final didAuthenticate = await auth.authenticate(
        localizedReason: "Por favor, autentique-se com sua digital",
        options: const AuthenticationOptions(
          biometricOnly: true,
        )
      );

      return didAuthenticate;
    } catch (e) {
      // print('Erro na autenticação: $e');
      return false;
    }
  }

  Future<User> authenticateWithPassword(String password) async {
    try {
      final json = await apiClient.post<Map<String, dynamic>>(ApiEndpoints.login, data: {
        'password': password,
      });

      return User.fromJson(json);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) {
        throw AppException(AppExceptionCode.CODE_007_AUTH_INVALID_CREDENTIALS, "Credêncial inválida");
      }

      if (status == 404) {
        throw AppException(AppExceptionCode.CODE_014_USER_NOT_FOUND, "Usuário não existe");
      }

      throw AppException(AppExceptionCode.CODE_012_AUTH_NETWORK_ERROR, "Senha incorreta");
    } catch (e) {
      throw AppException.errorUnexpected(e.toString());
    }
  }

}
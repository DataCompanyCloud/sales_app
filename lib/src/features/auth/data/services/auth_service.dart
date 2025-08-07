import 'package:sales_app/src/core/api/api_client.dart';
import 'package:sales_app/src/core/api/endpoints/api_endpoints.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';

class AuthService {
  final ApiClient apiClient;

  const AuthService(this.apiClient);

  Future<User> login(String login, String password) async {
    final json = await apiClient.post<Map<String, dynamic>>(ApiEndpoints.login, data: {
      'login': login,
      'password': password,
    });

    print(json);

    return User.fromJson(json);
  }
}
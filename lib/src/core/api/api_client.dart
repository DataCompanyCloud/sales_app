/// Interface para gerenciar api do servidor
abstract class ApiClient {
  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters});

  /// Enviar uma requisição post
  ///
  /// path: url completa
  Future<T> post<T>(String path, {dynamic data});
}
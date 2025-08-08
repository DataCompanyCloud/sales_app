
class ApiEndpoints {
  static const version = "v1";

  static const String login = '/login';

  /// /customers
  /// Rota para obter customers
  static const String customers = '/customers';
  static String customerById({required int customerId}) => '/customer/$customerId';

// Posts
  // static const String postsList     = '/posts';
  // static String      postById(int id) => '/posts/$id';

  /// /products
  /// Rpta para obter products
  static String products({required int start, required int end}) => '/products/$start/$end';
}
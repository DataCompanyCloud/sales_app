
class ApiEndpoints {

  /// /customers
  /// Rota para obter customers
  static const String customers = '/customers';

// Posts
  // static const String postsList     = '/posts';
  // static String      postById(int id) => '/posts/$id';

  /// /products
  /// Rpta para obter products
  static String products({required int start, required int end}) => '/products/$start/$end';
}
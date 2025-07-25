
class ApiEndpoints {

  /// /customers
  /// Rota para obter customers
  static String customers({required int start, required int end}) => '/customers/$start/$end';

// Posts
  // static const String postsList     = '/posts';
  // static String      postById(int id) => '/posts/$id';
}
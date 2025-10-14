
class ApiEndpoints {
  static const version = "v1";

  static const String login = '/login';
  static const String product = '/product';

  /// /customers
  /// Rota para obter customers
  static const String customers = '/customers';
  static String customerById({required int customerId}) => '/customer/$customerId';

// Posts
  // static const String postsList     = '/posts';
  // static String      postById(int id) => '/posts/$id';

  /// /products
  /// Rota para obter products
  static const String products = '/products';
  static String productById({required int productId}) => '/product/$productId';

  /// /orders
  /// Rota para obter orders
  static const String orders = '/orders';
  static String orderById({required int orderId}) => '/order/$orderId';

  /// /storage
  /// Rota para obter storages
  static const String storages = '/storage';
  static String storageById({required int storageId}) => '/storage/$storageId';
}
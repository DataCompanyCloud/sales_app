class ApiEndpoints {
  static const api = "api";
  static const version = "v1";

  // auth
  static const String login = '/$api/$version/auth/login';

  // products
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

  /// /stockTransaction
  /// Rota para obter stockTransactions
  static const String stockTransaction = '/stockTransaction';
  static String stockTransactionById({required int id}) => '/stockTransaction/$id';
}
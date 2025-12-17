class ApiEndpoints {
  static const api = "api";
  static const version = "v1";

  // auth
  static const String login = '/$api/$version/auth/login';

  // products
  static const String product = '/$api/$version/product';

  /// /customers
  /// Rota para obter customers
  static const String customers = '/$api/$version/customers';
  static String customerById({required int customerId}) => '/$api/$version/customer/$customerId';

// Posts
  // static const String postsList     = '/posts';
  // static String      postById(int id) => '/posts/$id';

  /// /products
  /// Rota para obter products
  static const String products = '/$api/$version/products';
  static String productById({required int productId}) => '/$api/$version/products/$productId';

  /// /orders
  /// Rota para obter orders
  static const String orders = '/$api/$version/orders';
  static String orderById({required int orderId}) => '/$api/$version/orders/$orderId';

  /// /storages
  /// Rota para obter storages
  static const String storages = '/$api/$version/storages';
  static String storageById({required int storageId}) => '/$api/$version/storages/$storageId';

  /// /stockTransaction
  /// Rota para obter stockTransactions
  static const String stockTransaction = '/$api/$version/stockTransactions';
  static String stockTransactionById({required int id}) => '/$api/$version/stockTransactions/$id';

}
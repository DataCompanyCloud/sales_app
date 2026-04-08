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
  static String customerByUuId({required String uuid}) => '/$api/$version/customers/$uuid';

// Posts
  // static const String postsList     = '/posts';
  // static String      postById(int id) => '/posts/$id';

  /// /products
  /// Rota para obter products
  static const String products = '/$api/$version/products';
  static String productByCode({required String code}) => '/$api/$version/products/${code.trim().toUpperCase()}';

  /// /orders
  /// Rota para obter orders
  static const String orders = '/$api/$version/orders';
  static String orderByUuId({required String uuid}) => '/$api/$version/orders/$uuid';

  /// /storages
  /// Rota para obter storages
  static const String storages = '/$api/$version/storages';
  static String storageByCode({required String code}) => '/$api/$version/storages/$code';
  static String storageProducts({required String storageCode}) => '/$api/$version/storages/$storageCode/products';
  static String storageProductByCode({required String storageCode, required String productCode}) => '/$api/$version/storages/${storageCode.trim().toUpperCase()}/products/${productCode.trim().toUpperCase()}';

  /// /stockTransaction
  /// Rota para obter stockTransactions
  static const String stockTransaction = '/$api/$version/stockTransactions';
  static String stockTransactionById({required int id}) => '/$api/$version/stockTransactions/$id';

}
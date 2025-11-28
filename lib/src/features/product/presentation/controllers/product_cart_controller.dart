import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';
import 'package:uuid/uuid.dart';

class ProductCartController extends Notifier<Map<int, SalesOrderProduct>> {

  @override
  Map<int, SalesOrderProduct> build() => {}; // vazio no começo

  void setProductQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      // REMOVE se a quantidade ficar 0
      final newState = {...state};
      newState.remove(product.productId);
      state = newState;
      return;
    }

    final salesOrderProduct = SalesOrderProduct.raw(
      productUuId: const Uuid().v4(),
      productId: product.productId,
      productCode: product.code,
      productName: product.name,
      quantity: quantity.toDouble(),
      unitPrice: product.price,
      images: product.imagePrimary,
      fiscal: product.fiscal,
      discountAmount: Money.zero(),
      taxResult: null,
    );

    state = {
      ...state,
      product.productId: salesOrderProduct,
    };
  }

  int getQuantity(int productId) {
    return state[productId]?.quantity.toInt() ?? 0;
  }
}

import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/data/models/product_model.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/product_wallet.dart';

@Entity()
class ProductWalletModel {
  @Id()
  int id;

  int ownerId;
  String walletCode;

  /// relação para o produto
  final product = ToOne<ProductModel>();

  ProductWalletModel({
    this.id = 0,
    required this.ownerId,
    required this.walletCode,
  });
}

extension ProductWalletModelMapper on ProductWalletModel {
  /// De ProductWalletModel → ProductWallet
  ProductWallet toEntity() => ProductWallet(ownerId: ownerId, walletCode: walletCode);
}

extension ProductWalletMapper on ProductWallet {
  /// De ProductWallet → ProductWalletModel
  ProductWalletModel toModel() => ProductWalletModel(ownerId: ownerId, walletCode: walletCode);
}
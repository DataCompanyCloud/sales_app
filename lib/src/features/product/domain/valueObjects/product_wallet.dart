import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_wallet.freezed.dart';
part 'product_wallet.g.dart';

@freezed
abstract class ProductWallet with _$ProductWallet {
  const ProductWallet._();

  const factory ProductWallet({
    required int ownerId,    // usuário
    required String walletCode,    // código da carteira
  }) = _ProductWallet;

  factory ProductWallet.fromJson(Map<String, dynamic> json) =>
      _$ProductWalletFromJson(json);
}
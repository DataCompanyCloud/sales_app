import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

// Flag de permissão para editar a página
final isMoreOptionsEditableProvider = StateProvider<bool>((ref) => false);

// Download das imagens
final currentDownloadingImageProvider = StateProvider<File?>((ref) => null);
final currentDownloadingProductProvider = StateProvider<Product?>((ref) => null);

// Salvar as imagens baixadas em uma lista
final downloadedImagePathProvider = StateProvider<String?>((ref) => '/data/user/0/com.datacompany.sales_app.sales_app/app_flutter/produto1.jpg');

// Download dos produtos
final isDownloadingProductsProvider = StateProvider<bool>((ref) => false);
final productDownloadProgressProvider = StateProvider<int>((ref) => 0);
final productListProvider = StateProvider<List<Product>>((ref) => []);

// Switches
final isCnpjRequiredProvider = StateProvider<bool>((ref) => false);
final isBlockSellingProvider = StateProvider<bool>((ref) => false);
final isHideItemProvider = StateProvider<bool>((ref) => false);
final isTablePriceProvider = StateProvider<bool>((ref) => false);
final isTablePriceAdjustedProvider = StateProvider<bool>((ref) => false);
final isSellingTableFixedProvider = StateProvider<bool>((ref) => false);

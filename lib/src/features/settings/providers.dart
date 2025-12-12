import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/images/data/services/image_service.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/sync_customer_controller.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/sync_products_controller.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_state.dart';

final syncProductsProvider = AsyncNotifierProvider<SyncProductsNotifier, SyncState>(
  SyncProductsNotifier.new,
);

final syncCustomersProvider = AsyncNotifierProvider<SyncCustomersNotifier, SyncState>(
  SyncCustomersNotifier.new,
);

// Cancelar Sincronização
final cancelProductSyncProvider = StateProvider<bool>((ref) => false);
final cancelCustomerSyncProvider = StateProvider<bool>((ref) => false);

// Flag de permissão para editar a página
final isMoreOptionsEditableProvider = StateProvider<bool>((ref) => false);

// Download das imagens
final currentDownloadingImageProvider = StateProvider<File?>((ref) => null);
final currentDownloadingProductProvider = StateProvider<Product?>((ref) => null);

// Salvar as imagens baixadas em uma lista
final downloadedImagePathProvider = StateProvider<String?>((ref) => '/data/user/0/com.datacompany.sales_app.sales_app/app_flutter/produto1.jpg');

// Download de clientes
final currentDownloadingCustomerProvider = StateProvider<Customer?>((ref) => null);

// Switches
final isCnpjRequiredProvider = StateProvider<bool>((ref) => false);
final isBlockSellingProvider = StateProvider<bool>((ref) => false);
final isHideItemProvider = StateProvider<bool>((ref) => false);
final isTablePriceProvider = StateProvider<bool>((ref) => false);
final isTablePriceAdjustedProvider = StateProvider<bool>((ref) => false);
final isSellingTableFixedProvider = StateProvider<bool>((ref) => false);


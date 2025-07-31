import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_controller_old.dart';

final productViewModelProvider = ChangeNotifierProvider((ref) {
  return ProductViewModel();
});

final productIndexProvider = StateProvider<int>((ref) => 0);
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_controller.dart';

final customerViewModelProvider = ChangeNotifierProvider((ref) {
  return CustomerViewModel();
});

final customerIndexProvider = StateProvider<int>((ref) => 3);
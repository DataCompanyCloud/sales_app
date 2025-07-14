import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/order/presentation/controllers/order_controller.dart';

final orderViewModelProvider = ChangeNotifierProvider((ref) {
  return OrderViewModel();
});

final orderIndexProvider = StateProvider<int>((ref) => 1);
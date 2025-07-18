import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/home/presentation/controllers/home_controller.dart';

final homeViewModelProvider = ChangeNotifierProvider((ref) {
  return HomeViewModel();
});

final previousTabIndexProvider = StateProvider<int>((ref) => 2);
final homeIndexProvider = StateProvider<int>((ref) => 2);
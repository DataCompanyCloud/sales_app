import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/auth/presentation/controllers/login_controller.dart';

final loginViewModelProvider = ChangeNotifierProvider((ref) {
  return LoginViewModel();
});
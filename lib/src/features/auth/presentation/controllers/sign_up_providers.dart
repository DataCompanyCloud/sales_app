import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/auth/presentation/controllers/sign_up_controller.dart';

final signupViewModelProvider = ChangeNotifierProvider((ref) {
  return SignupViewModel();
});
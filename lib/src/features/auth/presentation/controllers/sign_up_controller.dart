import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");

  bool isVisible = true;

  void toggleVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");

  bool isVisible = true;

  void emailValidator() {
    final email = emailController.text.trim();
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (email.isEmpty) {
      throw ArgumentError('Login: "email" cannot be empty.');
    }

    if (!regex.hasMatch(email)) {
      throw ArgumentError('Login: "email" format is invalid.');
    }
  }

  void toggleVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
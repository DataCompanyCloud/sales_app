import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");

  bool isVisible = true;
  bool invalidEmail = false;
  bool invalidPassword = false;

  void emailValidator() {
    final email = emailController.text.trim();
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (email != "user@gmail.com") {
      invalidEmail = true;
    } else {
      invalidEmail = false;
    }

    if (email.isEmpty) {
      throw ArgumentError('Login: "email" cannot be empty.');
    }

    if (!regex.hasMatch(email)) {
      throw ArgumentError('Login: "email" format is invalid.');
    }

    notifyListeners();
  }

  void passwordValidator() {
    final password = passwordController.text.trim();

    if (password != "123") {
      invalidPassword = true;
    } else {
      invalidPassword = false;
    }

    notifyListeners();
  }

  void toggleVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
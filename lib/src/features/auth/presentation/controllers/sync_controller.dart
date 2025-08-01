import 'package:flutter/material.dart';

class SyncController extends ChangeNotifier {
  int? isPressed = 0; // 0 = Recomendado, 1 = Tudo, Personalizado = 2

  void toggleOption(int optionIndex) {
    isPressed = optionIndex;
    notifyListeners();
  }

}
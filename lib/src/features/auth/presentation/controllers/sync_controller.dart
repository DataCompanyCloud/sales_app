import 'package:flutter/material.dart';

class SyncController extends ChangeNotifier {
  int? isPressed = 0; // 0 = Recomendado, 1 = Tudo, 2 = Personalizado
  final Set<String> selectedManualItems = {};

  void toggleOption(int optionIndex) {
    isPressed = optionIndex;
    if (optionIndex == 2) {
      selectedManualItems.clear();
    }

    notifyListeners();
  }

  void toggleManualItem(String item) {
    if (selectedManualItems.contains(item)) {
      selectedManualItems.remove(item);
    } else {
      selectedManualItems.add(item);
    }

    notifyListeners();
  }

  bool isManualItemSelected(String item) {
    return selectedManualItems.contains(item);
  }
}
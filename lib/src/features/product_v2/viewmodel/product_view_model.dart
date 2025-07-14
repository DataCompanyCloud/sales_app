/*
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {

  String filterSelectedInOrder = "";
  String option = "";

  int productNum = 0;

  String list1Option(String filter) {
    return filter = "Lista 1";
  }

  String list2Option(String filter) {
    return filter = "Lista 2";
  }

  String grid1Option(String filter) {
    return filter = "Grid 1";
  }

  String grid2Option(String filter) {
    return filter = "Grid 2";
  }

  void updateFilterType(String filter) {
    filterSelectedInOrder = filter;
    option = filter;
    notifyListeners();
  }


  void selectedFilterType() {
    final String filter = "";

    if (filterSelectedInOrder == "Lista 1") {
      option = list1Option(filter);
      notifyListeners();
      return;
    }

    if (filterSelectedInOrder == "Lista 2") {
      option = list2Option(filter);
      notifyListeners();
      return;
    }

    if (filterSelectedInOrder == "Grid 1") {
      option = grid1Option(filter);
      notifyListeners();
      return;
    }

    if (filterSelectedInOrder == "Grid 2") {
      option = grid2Option(filter);
      notifyListeners();
      return;
    }
  }

  void incrementProduct() {
    productNum++;

    notifyListeners();
  }

  void decrementProduct() {
    productNum--;

    notifyListeners();
  }
}
*/
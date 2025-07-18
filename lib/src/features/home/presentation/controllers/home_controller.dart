import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {

  BottomNavigationBarItem buildNavItem({
    required int index,
    required IconData iconData,
    required String label,
    required int currentIndex,
  }) {
    final isSelected = index == currentIndex;

    return BottomNavigationBarItem(
      icon: isSelected
          ? CircleAvatar(
        radius: 20,
        backgroundColor: Color(0xFF0081F5),
        child: Icon(
          iconData,
          color: Colors.white,
          size: 28,
        ),
      )
          : Icon(iconData, size: 24),
      label: label,
    );
  }
}
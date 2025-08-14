import 'package:flutter/material.dart';

enum DeviceType {
  mobile, tablet
}

class MyDevice {

  static DeviceType getType(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 600) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }
}

import 'package:flutter/material.dart';

extension ColorOpacity on Color {
  Color withOpacityFixed(double opacity) {
    final alpha = (opacity * 255).roundToDouble();
    return withValues(alpha: alpha);
  }
}
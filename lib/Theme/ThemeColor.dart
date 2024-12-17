import 'package:flutter/material.dart';

class ThemeColor {
  static const Color darkgreyTheme = Color.fromARGB(255, 58, 58, 58);
  static const Color lightgreyTheme = Color.fromARGB(255, 208, 208, 208);
  static const Color offwhiteTheme = Color.fromARGB(255, 254, 246, 255);
  static const Color blueTheme = Color.fromARGB(255, 33, 59, 208);
  static const Color studentTheme = Color.fromARGB(255, 9, 22, 95);
  static const Color teacherTheme = Color.fromARGB(255, 4, 68, 20);
  static const Color errorTheme = Colors.red;

  static List<Color> generatePastelColors(int n) {
    // Generate a list of pastel colors
    List<Color> colors = [];
    for (int i = 0; i < n; i++) {
      final hue = (i * 360 / n) % 360;
      final color = HSVColor.fromAHSV(0.9, hue, 0.5, 0.5).toColor();
      colors.add(color);
    }
    return colors;
  }
}
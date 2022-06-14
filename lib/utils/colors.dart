import 'package:flutter/material.dart';

class ThemeColors {
  static int backgroundColorHex = 0xFF2D2D2D;
  static Color backgroundColor = const Color(0xFF2D2D2D);

  static Color primaryColor = const Color(0xFF75DEFF);

  static Map<int, Color> backgroundColorMaterial = {
    50: const Color(0xFF2D2D2D).withOpacity(.1),
    100: const Color(0xFF2D2D2D).withOpacity(.2),
    200: const Color(0xFF2D2D2D).withOpacity(.3),
    300: const Color(0xFF2D2D2D).withOpacity(.4),
    400: const Color(0xFF2D2D2D).withOpacity(.5),
    500: const Color(0xFF2D2D2D).withOpacity(.6),
    600: const Color(0xFF2D2D2D).withOpacity(.7),
    700: const Color(0xFF2D2D2D).withOpacity(.8),
    800: const Color(0xFF2D2D2D).withOpacity(.9),
    900: const Color(0xFF2D2D2D).withOpacity(1),
  };
}

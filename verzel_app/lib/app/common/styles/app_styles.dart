import 'package:flutter/material.dart';

class AppStyles {
  // Colors of app:
  final primaryColor = const Color.fromRGBO(51, 116, 219, 1); // Cor análoga 5
  final primaryColorInt = 0xFF2036F3; //cor do cursor e textos de label ou hint
  final blackColor = const Color(0xFF231F20);
  final secondaryColor2 = const Color.fromARGB(255, 35, 88, 202);
  final secondaryColor3 = const Color.fromARGB(255, 110, 110, 110);
  final colorWhite = Colors.white;

  Color failureScreenColor = const Color(0xFFEB4C5F);
  Color successScreenColor = const Color(0xFF04CD51);

  Map<int, Color> getSwatch() {
    return {
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    };
  }

  final loginPath = "lib/app/common/assets/png/logo.png";
  final logoPath = "lib/app/common/assets/png/logo.png";
}

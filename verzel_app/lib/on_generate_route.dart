import "package:flutter/material.dart";
import "package:verzel_app/app/layers/presenter/screens/logged_in/main_menu_screen.dart";
import "package:verzel_app/app/layers/presenter/screens/not_logged_in/login/login.dart";
import "package:verzel_app/starter.dart";
import "package:responsive_sizer/responsive_sizer.dart";

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final args =
      settings.arguments != null ? settings.arguments as List<dynamic> : null;
  switch (settings.name) {
    case Starter.route:
      return MaterialPageRoute(
        builder: (context) => ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return const Starter();
          },
        ),
      );
    case MainMenuScreen.route:
      return pageRouteBuilder(
        const MainMenuScreen(),
      );
    case Login.route:
      return pageRouteBuilder(
        const Login(),
      );

  }

  return null;
}

PageRouteBuilder pageRouteBuilder(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, a1, a2) => screen,
    transitionsBuilder: (context, a1, a2, child) =>
        FadeTransition(opacity: a1, child: child),
  );
}

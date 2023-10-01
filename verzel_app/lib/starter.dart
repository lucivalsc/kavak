import 'package:flutter/material.dart';
import 'package:verzel_app/app/layers/presenter/screens/logged_in/main_menu_screen.dart';

import 'app/layers/presenter/screens/not_logged_in/splash/splash_screen.dart';

class Starter extends StatefulWidget {
  const Starter({Key? key}) : super(key: key);

  static const route = "starter_screen";

  @override
  State<Starter> createState() => _StarterState();
}

class _StarterState extends State<Starter> {
  late Future<void> future;
  late Widget nextScreen;

  Future<void> startApp() async {
    nextScreen = const MainMenuScreen();
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    future = startApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: nextScreen,
          );
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: SplashScreen(),
          );
        }
      },
    );
  }
}

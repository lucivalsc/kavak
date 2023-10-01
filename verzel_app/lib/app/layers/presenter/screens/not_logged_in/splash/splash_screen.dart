import 'package:flutter/material.dart';
import 'package:verzel_app/app/common/styles/app_styles.dart';

class SplashScreen extends StatelessWidget {
  final appStyles = AppStyles();

  SplashScreen({Key? key}) : super(key: key);

  static const String route = "splash";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStyles.colorWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              appStyles.loginPath,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ],
        ),
      ),
    );
  }
}

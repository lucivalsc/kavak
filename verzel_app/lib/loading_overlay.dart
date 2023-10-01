import 'package:flutter/material.dart';
import 'package:verzel_app/loading_screen.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingOverlay(
      {super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading ? const LoadingScreen() : const SizedBox.shrink(),
      ],
    );
  }
}


import 'package:flutter/material.dart';

class CircularWidget extends StatelessWidget {
  const CircularWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey,
      ),
    );
  }
}
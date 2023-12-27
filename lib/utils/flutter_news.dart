import 'package:flutter/material.dart';
import 'package:news_app/utils/constants.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "FLUTTER",
          style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
              decoration: TextDecoration.none),
        ),
        Text(
          "NEWS",
          style: TextStyle(
              fontSize: 30, color: kwhite, decoration: TextDecoration.none),
        ),
      ],
    );
  }
}

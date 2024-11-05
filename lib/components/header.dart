import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;

  const CustomHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95.0,
      color: const Color(0xFF4B2FB8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC443),
            ),
          ),
        ),
      ),
    );
  }
}

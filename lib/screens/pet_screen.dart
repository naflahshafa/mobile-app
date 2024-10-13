import 'package:flutter/material.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Pet Screen',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ));
  }
}

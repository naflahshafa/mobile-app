import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Task Screen',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ));
  }
}
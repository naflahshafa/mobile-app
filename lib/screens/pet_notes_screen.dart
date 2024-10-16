import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class PetNotesScreen extends StatelessWidget {
  final Pet pet;

  const PetNotesScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Background color
      appBar: AppBar(
        title: Text('${pet.name} Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Notes for ${pet.name}', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text('Type: ${pet.type}', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

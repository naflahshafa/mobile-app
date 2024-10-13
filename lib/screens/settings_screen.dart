import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20), // Add some spacing
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login'); // Navigate to Login Page
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 10), // Add some spacing
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register'); // Navigate to Register Page
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

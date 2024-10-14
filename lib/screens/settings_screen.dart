import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add some padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50, // Adjust the radius for profile picture
                backgroundImage: AssetImage(
                    'assets/images/your_profile_image.png'), // Replace with your image asset
                child: const Icon(Icons.person,
                    size: 50, color:Colors.grey), // Placeholder icon if image not loaded
              ),
              const SizedBox(height: 20),
              const Text(
                'Naflah Shafa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // Add spacing
              ElevatedButton(
                onPressed: () {
                  // Navigate to Edit Profile Page
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // Full-width button
                  backgroundColor: Colors.white, // Button background color
                  elevation: 0, // No shadow
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
              const SizedBox(height: 10), // Add some spacing
              ElevatedButton(
                onPressed: () {
                  // Navigate to Logout functionality
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // Full-width button
                  backgroundColor: Colors.white, // Button background color
                  elevation: 0, // No shadow
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

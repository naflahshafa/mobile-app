import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/dummy_data.dart';

class PetProfileScreen extends StatelessWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF7B3A10),
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFF4F4F4)),
              onPressed: () {
                context.go('/pets');
              },
            ),
            const Text(
              'Back',
              style: TextStyle(color: Color(0xFFF4F4F4), fontSize: 16),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Image.network(
                          pet.imageUrl?.isNotEmpty == true
                              ? pet.imageUrl!
                              : 'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey,
                              child: const Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon based on pet's sex
                          Icon(
                            pet.sex == 'Male' ? Icons.male : Icons.female,
                            size: 30,
                            color: Colors.brown,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            pet.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildProfileDetail(
                          'Date of Birth', pet.birthDate.toString()),
                      _buildProfileDetail('Breed', pet.breed),
                      _buildProfileDetail('Category', pet.type),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          _buildActionButton(
                            label: 'Edit Pet Profile',
                            color: Colors.blue,
                            onPressed: () {
                              context
                                  .push('/pets/profile/editProfile', extra: pet)
                                  .then((value) {
                                if (value != null && value is Pet) {
                                  // Update local pet with returned value
                                  // You might use state management here to handle this globally
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildActionButton(
                            label: 'Delete Pet',
                            color: Colors.red,
                            onPressed: () {
                              // Implement delete functionality here
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/services/pet_service.dart';
import '../../../data/models/pet_model.dart';

class PetProfileScreen extends StatefulWidget {
  final String petId;

  const PetProfileScreen({super.key, required this.petId});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final PetService _petService = PetService();
  Pet? pet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPetDetails();
  }

  Future<void> _loadPetDetails() async {
    try {
      final loadedPet = await _petService.getPetById(widget.petId);
      setState(() {
        pet = loadedPet;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading pet details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deletePet() async {
    try {
      await _petService.deletePet(pet!.id);

      _showDialog(context, 'Success', 'Pet deleted successfully!');
    } catch (e) {
      print('Error deleting pet: $e');

      _showDialog(
          context, 'Error', 'Failed to delete pet. Please try again later.');
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (title == 'Success') {
                  context.go('/pets');
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: const Color(0xFF7B3A10),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (pet == null) {
      return Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: const Color(0xFF7B3A10),
        body: const Center(child: Text('Pet not found.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: _buildAppBar(context),
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
                          pet!.imageProfile.isNotEmpty
                              ? pet!.imageProfile
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
                          Icon(
                            pet!.gender == 'male' ? Icons.male : Icons.female,
                            size: 30,
                            color: Colors.brown,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            pet!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildProfileDetail('Date of Birth', pet!.birthDate),
                      _buildProfileDetail('Breed', pet!.breed),
                      _buildProfileDetail('Category', pet!.animalCategory),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          _buildActionButton(
                            label: 'Edit Pet Profile',
                            color: Colors.blue,
                            onPressed: () {
                              context
                                  .push('/pets/profile/${pet!.id}/editProfile',
                                      extra: pet)
                                  .then((value) {
                                if (value != null && value is Pet) {
                                  setState(() {
                                    pet = value;
                                  });
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildActionButton(
                            label: 'Delete Pet',
                            color: Colors.red,
                            onPressed: () {
                              _showConfirmationDialog(context);
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  Widget _buildProfileDetail(String label, dynamic value) {
    String displayValue;

    if (value is DateTime) {
      displayValue = DateFormat('yyyy-MM-dd').format(value);
    } else {
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(displayValue),
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Pet'),
          content: const Text('Are you sure you want to delete this pet?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePet();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

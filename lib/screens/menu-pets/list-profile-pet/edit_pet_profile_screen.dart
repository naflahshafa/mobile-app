import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../../data/services/pet_service.dart';
import '../../../data/models/pet_model.dart';

class EditPetProfileScreen extends StatefulWidget {
  final Pet pet;

  const EditPetProfileScreen({super.key, required this.pet});

  @override
  _EditPetProfileScreenState createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends State<EditPetProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late DateTime birthDate;
  late String gender;
  late String breed;
  late String animalCategory;
  String? imageProfile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name = widget.pet.name;
    birthDate = widget.pet.birthDate;
    gender = widget.pet.gender;
    breed = widget.pet.breed;
    animalCategory = widget.pet.animalCategory;
    imageProfile = widget.pet.imageProfile;
  }

  Future<void> _uploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        imageProfile = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
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
                        const Text(
                          'Edit Pet Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: imageProfile != null &&
                                      imageProfile!.isNotEmpty
                                  ? FileImage(File(imageProfile!))
                                  : NetworkImage(
                                      widget.pet.imageProfile.isNotEmpty
                                          ? widget.pet.imageProfile
                                          : 'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260',
                                    ) as ImageProvider,
                            ),
                            Positioned(
                              bottom: -7,
                              right: -10,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add_a_photo,
                                      color: Color(0xFF333333)),
                                  onPressed: () async {
                                    await _uploadImage();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Name',
                          icon: Icons.edit,
                          onChanged: (value) => name = value,
                          initialValue: name,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: _buildTextField(
                              label: 'Date of Birth',
                              icon: Icons.calendar_today,
                              initialValue:
                                  birthDate.toLocal().toString().split(' ')[0],
                              onChanged: (value) {}, // Format tanggal
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'male',
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value!;
                                    });
                                  },
                                ),
                                const Text('Male'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'female',
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value!;
                                    });
                                  },
                                ),
                                const Text('Female'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          label: 'Breed',
                          icon: Icons.pets,
                          onChanged: (value) => breed = value,
                          initialValue: breed,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: animalCategory,
                          decoration: const InputDecoration(
                            labelText: 'Animal Category',
                            prefixIcon: Icon(Icons.category),
                            border: OutlineInputBorder(),
                          ),
                          items: Pet.getAnimalCategories()
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              animalCategory = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              label: 'Cancel',
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 10),
                            _buildActionButton(
                              label: 'Update',
                              color: Colors.blue,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final updatedPet = widget.pet.copyWith(
                                    name: name,
                                    birthDate: birthDate,
                                    gender: gender,
                                    breed: breed,
                                    animalCategory: animalCategory,
                                    imageProfile: imageProfile,
                                  );

                                  await _updatePetInBackend(updatedPet);

                                  Navigator.pop(context, updatedPet);
                                }
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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(100, 50),
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

  Future<void> _updatePetInBackend(Pet pet) async {
    try {
      await PetService().updatePet(
        id: pet.id,
        name: pet.name,
        animalCategory: pet.animalCategory,
        birthDate: pet.birthDate,
        breed: pet.breed,
        gender: pet.gender,
        imageProfile: pet.imageProfile,
      );

      _showDialog(context, 'Success', 'Pet profile updated successfully!');

      // Wait for the dialog to close before popping the screen
      await Future.delayed(const Duration(seconds: 3));

      GoRouter.of(context).pop();
    } catch (e) {
      print('Error updating pet: $e');
      _showDialog(context, 'Error',
          'Failed to update pet profile. Please try again later.');
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
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

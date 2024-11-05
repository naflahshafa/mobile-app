import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../components/bottom_navbar.dart';
import '../../components/header.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  int currentIndex = 3;
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String? imageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Pet Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey, // Associate Form with GlobalKey
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
                          'Edit Profile', // Title added here
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            height: 20), // Space between title and image
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: (imageUrl != null &&
                                      imageUrl!.isNotEmpty)
                                  ? FileImage(File(
                                      imageUrl!)) // Uploaded image if available
                                  : const NetworkImage(
                                      'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260', // Default image
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Color(0xFF333333)),
                                  onPressed:
                                      _uploadImage, // Call function to upload image
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Username',
                          icon: Icons.person,
                          onChanged: (value) => username = value,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          label: 'Email',
                          icon: Icons.email,
                          onChanged: (value) => email = value,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              label: 'Cancel',
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(
                                    context); // Go back without changes
                              },
                            ),
                            const SizedBox(width: 10),
                            _buildActionButton(
                              label: 'Update',
                              color: Colors.blue,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, go back with updated data
                                  Navigator.pop(
                                    context,
                                    {
                                      'username': username,
                                      'email': email,
                                      'imageUrl': imageUrl
                                    },
                                  );
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index; // Update the current index
          });
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextFormField(
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
        return null; // Return null if input is valid
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
}

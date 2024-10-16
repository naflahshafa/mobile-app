import 'package:flutter/material.dart';
import '../components/bottom_navbar.dart';
import '../components/header.dart';
import '../data/dummy_data.dart';

class AddPetNoteScreen extends StatefulWidget {
  const AddPetNoteScreen({super.key});

  @override
  _AddPetNoteScreenState createState() => _AddPetNoteScreenState();
}

class _AddPetNoteScreenState extends State<AddPetNoteScreen> {
  int currentIndex = 1; // Set default index for BottomNavigationBar
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    // Initialize fields
    title = '';
    description = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Pet Notes'), // Use CustomHeader
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey, // Associate the Form with GlobalKey
          child: SingleChildScrollView(
            child: Card(
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
                      'Add Pet Note',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Space between title and fields
                    _buildTextField(
                      label: 'Title',
                      icon: Icons.title,
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 10), // Space between fields
                    _buildTextField(
                      label: 'Description',
                      icon: Icons.description,
                      onChanged: (value) => description = value,
                      maxLines: 5, // Allow multiple lines for description
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          label: 'Cancel',
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context); // Go back without changes
                          },
                        ),
                        const SizedBox(width: 10),
                        _buildActionButton(
                          label: 'Save',
                          color: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If form is valid, pop with new note data
                              Navigator.pop(
                                context,
                                Note(
                                  title: title,
                                  description: description,
                                  // Add other fields if needed
                                ),
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
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index; // Update the current index when tapped
          });
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? initialValue,
    int maxLines = 1, // Default to 1 line
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon), // The icon aligned with the text
            const SizedBox(width: 8), // Space between icon and label
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8), // Space between label and text field
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
            // Removed labelText to avoid redundancy
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label'; // Validation message
            }
            return null; // Return null if input is valid
          },
        ),
      ],
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

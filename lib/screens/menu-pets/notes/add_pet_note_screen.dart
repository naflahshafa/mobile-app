import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../components/header.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/models/note_model.dart';
import '../../../data/services/pet_service.dart';
import '../../../data/services/note_service.dart';

class AddPetNoteScreen extends StatefulWidget {
  const AddPetNoteScreen({super.key});

  @override
  _AddPetNoteScreenState createState() => _AddPetNoteScreenState();
}

class _AddPetNoteScreenState extends State<AddPetNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  String? selectedCategory;
  String? selectedPetUid;
  List<Pet> pets = [];

  @override
  void initState() {
    super.initState();
    title = '';
    description = '';
    selectedCategory = Note.getNoteCategories().first;
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    List<Pet> fetchedPets = await PetService().getAllPetsByUserUid();
    setState(() {
      pets = fetchedPets;
      if (pets.isNotEmpty) {
        selectedPetUid = pets.first.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Add Pet Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
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
                    _buildTextField(
                      label: 'Title',
                      icon: Icons.title,
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: 'Description',
                      icon: Icons.description,
                      onChanged: (value) => description = value,
                      maxLines: 5, // multiple lines for description
                    ),
                    const SizedBox(height: 20),
                    if (pets.isNotEmpty)
                      _buildDropdownField(
                        label: 'Pet',
                        icon: Icons.pets,
                        value: selectedPetUid,
                        items: pets.map((pet) {
                          return DropdownMenuItem<String>(
                            value: pet.id,
                            child: Text(pet.name),
                          );
                        }).toList(),
                        onChanged: (newPetUid) {
                          setState(() {
                            selectedPetUid = newPetUid;
                          });
                        },
                        placeholder: 'Select a pet',
                      ),
                    const SizedBox(height: 20),
                    _buildDropdownField(
                      label: 'Category',
                      icon: Icons.category,
                      value: selectedCategory,
                      items: Note.getNoteCategories().map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newCategory) {
                        setState(() {
                          selectedCategory = newCategory;
                        });
                      },
                      placeholder: 'Select category',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          label: 'Cancel',
                          color: Colors.red,
                          onPressed: () {
                            // Navigator.pop(context);
                            context.go('/pets', extra: {'tabIndex': 1});
                          },
                        ),
                        const SizedBox(width: 10),
                        _buildActionButton(
                          label: 'Save',
                          color: Colors.blue,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (selectedPetUid != null) {
                                try {
                                  await NoteService().addNote(
                                    petUid: selectedPetUid!,
                                    noteCategory: selectedCategory!,
                                    title: title,
                                    description: description,
                                  );

                                  _showDialog('Success',
                                      'Pet note added successfully.');

                                  Navigator.pop(context);
                                } catch (e) {
                                  _showDialog('Error',
                                      'Failed to add pet note. Please try again.');
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please select a pet.')),
                                );
                              }
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
    );
  }

  void _showDialog(String title, String message) {
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

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Navigator.of(context).pop();
        context.go('/pets', extra: {'tabIndex': 1});
      }
    });
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? initialValue,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
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
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
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
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
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
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey.shade400,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(placeholder),
              onChanged: onChanged,
              underline: const SizedBox(),
              items: items,
            ),
          ),
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

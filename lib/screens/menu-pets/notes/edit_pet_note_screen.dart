import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../components/header.dart';
import '../../../data/models/note_model.dart';
import '../../../data/services/note_service.dart';

class EditPetNoteScreen extends StatefulWidget {
  final String noteId;
  final String petUid;

  const EditPetNoteScreen({
    super.key,
    required this.noteId,
    required this.petUid,
  });

  @override
  _EditPetNoteScreenState createState() => _EditPetNoteScreenState();
}

class _EditPetNoteScreenState extends State<EditPetNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String noteCategory;
  late String petName;
  String? selectedCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedCategory = Note.getNoteCategories().first;
    _loadNoteData();
  }

  Future<void> _loadNoteData() async {
    try {
      final data = await NoteService().getNoteAndPetNameByIdAndPetUid(
        widget.noteId,
        widget.petUid,
      );

      setState(() {
        title = data['note']['title'];
        description = data['note']['description'];
        noteCategory = data['note']['note_category'];
        petName = data['pet_name'];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading note data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateNote() async {
    if (_formKey.currentState!.validate()) {
      await NoteService().updateNote(
        id: widget.noteId,
        noteCategory: noteCategory,
        title: title,
        description: description,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Edit Pet Note'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                          Row(
                            children: [
                              const Icon(Icons.pets),
                              const SizedBox(width: 8),
                              Text(
                                petName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            label: 'Title',
                            icon: Icons.title,
                            onChanged: (value) => title = value,
                            initialValue: title,
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            label: 'Description',
                            icon: Icons.description,
                            onChanged: (value) => description = value,
                            initialValue: description,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 10),
                          _buildDropdownField(
                            label: 'Category',
                            icon: Icons.category,
                            value: noteCategory,
                            items: Note.getNoteCategories().map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (newCategory) {
                              setState(() {
                                noteCategory = newCategory!;
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
                                  context.go(
                                      '/pets/noteDetail/${widget.noteId}/${widget.petUid}');
                                },
                              ),
                              const SizedBox(width: 10),
                              _buildActionButton(
                                label: 'Save',
                                color: Colors.blue,
                                onPressed: _updateNote,
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
    required String value,
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

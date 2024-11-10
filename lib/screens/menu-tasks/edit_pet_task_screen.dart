import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/header.dart';
import '../../data/dummy_data.dart';

class EditPetTaskScreen extends StatefulWidget {
  final Task task;
  final String petName;

  const EditPetTaskScreen({required this.task, required this.petName, Key? key})
      : super(key: key);

  @override
  _EditPetTaskScreenState createState() => _EditPetTaskScreenState();
}

class _EditPetTaskScreenState extends State<EditPetTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String selectedPet;
  late String title;
  late String description;
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    selectedPet = widget.petName;
    title = widget.task.title;
    description = widget.task.description;

    // Change the date format to parse from 'dd-MM-yyyy' to 'yyyy-MM-dd'
    dueDate = DateFormat('yyyy-MM-dd')
        .parse(widget.task.time);
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.brown,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Edit Pet Task'),
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
                    // const Text(
                    //   'Edit Pet Task',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const SizedBox(height: 5),
                    _buildPetDropdown(),
                    const SizedBox(height: 10),
                    _buildDateField(
                      'Due Date',
                      dueDate,
                      () => _selectDueDate(context),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: 'Title',
                      icon: Icons.title,
                      initialValue: title,
                      onChanged: (value) => title = value,
                      placeholder: 'Enter task title',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: 'Description',
                      icon: Icons.description,
                      initialValue: description,
                      onChanged: (value) => description = value,
                      maxLines: 5,
                      placeholder: 'Enter task description',
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
                          label: 'Save',
                          color: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(
                                context,
                                {
                                  'pet': selectedPet,
                                  'dueDate': dueDate != null
                                      ? DateFormat('yyyy-MM-dd').format(
                                          dueDate!) // Ensuring the format is yyyy-MM-dd
                                      : '',
                                  'title': title,
                                  'description': description,
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
          ),
        ),
      ),
    );
  }

  Widget _buildPetDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.pets),
            SizedBox(width: 8),
            Text(
              'Pet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedPet,
          items: pets.map((pet) {
            return DropdownMenuItem<String>(
              value: pet.name,
              child: Text(pet.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedPet = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.calendar_today),
            SizedBox(width: 8),
            Text(
              'Due Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: const Icon(Icons.calendar_today),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            ),
            child: Text(
              date != null
                  ? DateFormat('yyyy-MM-dd')
                      .format(date) // Changed to yyyy-MM-dd
                  : 'Select date',
              style: TextStyle(
                fontSize: 16,
                color: date == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? initialValue,
    int maxLines = 1,
    required String placeholder, // Added placeholder parameter
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
            hintText: placeholder, // Set the placeholder here
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

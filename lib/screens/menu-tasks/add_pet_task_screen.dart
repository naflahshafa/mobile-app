import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../components/header.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/services/pet_service.dart';
import '../../../data/services/task_service.dart';

class AddPetTaskScreen extends StatefulWidget {
  const AddPetTaskScreen({super.key});

  @override
  _AddPetTaskScreenState createState() => _AddPetTaskScreenState();
}

class _AddPetTaskScreenState extends State<AddPetTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPetUid;
  List<Pet> pets = [];
  late String title;
  late String description;
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    title = '';
    description = '';
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

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(dueDate ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        await TaskService().addTask(
          petUid: selectedPetUid!,
          title: title,
          description: description,
          dueDate: dueDate!,
          isCompleted: false,
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Task has been added successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/tasks');
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to save task: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Add Pet Task'),
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
                    pets.isNotEmpty
                        ? _buildDropdownField(
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
                                selectedPetUid = newPetUid!;
                              });
                            },
                            placeholder: 'Select a pet',
                          )
                        : const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    _buildDateField(
                      'Due Date & Time',
                      dueDate,
                      () => _selectDueDate(context),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: 'Title',
                      icon: Icons.title,
                      onChanged: (value) => title = value,
                      hintText: 'Enter task title',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: 'Description',
                      icon: Icons.description,
                      onChanged: (value) => description = value,
                      maxLines: 5,
                      hintText: 'Enter task description',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          label: 'Cancel',
                          color: Colors.red,
                          onPressed: () {
                            context.go('/tasks');
                          },
                        ),
                        const SizedBox(width: 10),
                        _buildActionButton(
                          label: 'Save',
                          color: Colors.blue,
                          onPressed: _saveTask,
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

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.calendar_today),
            SizedBox(width: 8),
            Text(
              'Due Date & Time',
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
                  ? DateFormat('yyyy-MM-dd HH:mm').format(date)
                  : 'Select date and time',
              style: TextStyle(
                fontSize: 16,
                color: date == null ? Colors.grey[600] : Colors.black,
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
    String? hintText,
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
            hintText: hintText,
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

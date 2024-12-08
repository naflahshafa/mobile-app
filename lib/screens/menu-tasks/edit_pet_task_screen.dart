import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../components/header.dart';
import '../../data/services/task_service.dart';

class EditPetTaskScreen extends StatefulWidget {
  final String taskId;
  final String petUid;

  const EditPetTaskScreen({
    required this.taskId,
    required this.petUid,
    Key? key,
  }) : super(key: key);

  @override
  _EditPetTaskScreenState createState() => _EditPetTaskScreenState();
}

class _EditPetTaskScreenState extends State<EditPetTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String petName = '';
  late String title = '';
  late String description = '';
  DateTime? dueDate;
  late bool isCompleted = false;
  bool isLoading = true;
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  Future<void> _loadTaskData() async {
    try {
      // print(
      //     'Loading task data for taskId: ${widget.taskId}, petUid: ${widget.petUid}');
      var taskData = await _taskService.getTaskAndPetNamesByIdAndPetUid(
        widget.taskId,
        widget.petUid,
      );

      // print('Fetched task data: $taskData');

      setState(() {
        title = taskData['task']['title'];
        description = taskData['task']['description'];

        final dueDateRaw = taskData['task']['due_date'];
        if (dueDateRaw is Timestamp) {
          dueDate = dueDateRaw.toDate();
        } else if (dueDateRaw is String) {
          dueDate = DateTime.parse(dueDateRaw);
        } else {
          dueDate = null;
        }

        petName = taskData['pet_name'] ?? 'Unknown';
        isCompleted = taskData['task']['isCompleted'];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading task data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading task: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF7B3A10),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(95.0),
          child: CustomHeader(title: 'Edit Pet Task'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.pets, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          petName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                    const SizedBox(height: 10),
                    _buildDateField(
                      'Due Date',
                      dueDate,
                      () => _selectDueDate(context),
                    ),
                    const SizedBox(height: 10),
                    _buildCompletionSwitch(),
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await _taskService.updateTask(
                                  id: widget.taskId,
                                  title: title,
                                  description: description,
                                  dueDate: dueDate,
                                  isCompleted: isCompleted,
                                );

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                        'Task has been updated successfully.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.pushReplacement(
                                            '/tasks/taskDetail/${widget.taskId}/${widget.petUid}?refresh=true',
                                          );
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
                                    content: Text('Failed to update task: $e'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
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
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: placeholder,
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

  Widget _buildCompletionSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Mark as completed'),
          value: isCompleted,
          onChanged: (bool value) {
            setState(() {
              isCompleted = value;
            });
          },
          activeColor: Colors.green,
          inactiveThumbColor: Colors.grey,
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

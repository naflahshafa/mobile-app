import 'package:flutter/material.dart';
// import '../../components/bottom_navbar.dart';
import '../../components/header.dart';
import '../../data/dummy_data.dart';
import 'edit_pet_task_screen.dart';

class PetTaskDetailPage extends StatefulWidget {
  final DummyTask task;
  final DummyPet pet;

  const PetTaskDetailPage({super.key, required this.task, required this.pet});

  @override
  _PetTaskDetailPageState createState() => _PetTaskDetailPageState();
}

class _PetTaskDetailPageState extends State<PetTaskDetailPage> {
  // int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Detail Pet Task'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFFFF1EC)),
              label: const Text(
                'Back',
                style: TextStyle(color: Color(0xFFFFF1EC)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        widget.task.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.pets),
                          const SizedBox(width: 8),
                          Text(
                            widget.pet.name, // Get pet's name
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.task.description,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            widget.task.time,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 45), // Full width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPetTaskScreen(
                                task: widget.task, // Pass the task object
                                petName: widget.pet.name, // Pass the pet name
                              ),
                            ),
                          ).then((updatedTask) {
                            if (updatedTask != null) {
                              // Handle the updated task if needed
                            }
                          });
                        },
                        child: const Text('Edit Task'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Action to delete task
                        },
                        child: const Text('Delete Task'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../components/header.dart';
import '../../data/services/task_service.dart';

class PetTaskDetailPage extends StatefulWidget {
  final String taskId;
  final String petUid;

  const PetTaskDetailPage({
    super.key,
    required this.taskId,
    required this.petUid,
  });

  @override
  _PetTaskDetailPageState createState() => _PetTaskDetailPageState();
}

class _PetTaskDetailPageState extends State<PetTaskDetailPage> {
  final TaskService _taskService = TaskService();
  late Future<Map<String, dynamic>> _taskAndPetFuture;

  @override
  void initState() {
    super.initState();
    _loadTaskAndPetData();
  }

  void _loadTaskAndPetData() {
    _taskAndPetFuture = _taskService.getTaskAndPetNamesByIdAndPetUid(
      widget.taskId,
      widget.petUid,
    );
  }

  String formatDueDate(dynamic dueDateValue) {
    String dueDate = 'No due date';
    if (dueDateValue != null) {
      try {
        DateTime dueDateTime = (dueDateValue as Timestamp).toDate();
        dueDate = DateFormat('yyyy-MM-dd – hh:mm a').format(dueDateTime);
      } catch (e) {
        print('Error parsing due_date: $e');
      }
    }
    return dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Detail Pet Task'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _taskAndPetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final task = snapshot.data!['task'];
          final petName = snapshot.data!['pet_name'];

          return Column(
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
                    if (mounted) {
                      context.go('/tasks');
                    }
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
                            task['title'] ?? '',
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
                                petName,
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
                                  task['description'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 8),
                              Text(
                                formatDueDate(task['due_date']),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (mounted) {
                                context.go(
                                  '/tasks/taskDetail/${widget.taskId}/${widget.petUid}/editPetTask',
                                );
                              }
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
                            onPressed: () async {
                              final confirmation = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const Text(
                                        'Are you sure you want to delete this task?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmation == true) {
                                try {
                                  await _taskService.deleteTask(widget.taskId);
                                  if (mounted) {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Success'),
                                          content: const Text(
                                              'Task deleted successfully.'),
                                          actions: [
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
                                    context.go('/tasks');
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content:
                                              Text('Failed to delete task: $e'),
                                          actions: [
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
                              }
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
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: const Color(0xFF7B3A10),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

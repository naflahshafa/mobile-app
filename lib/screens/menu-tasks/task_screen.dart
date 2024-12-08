import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../components/header.dart';
import '../../data/services/pet_service.dart';
import '../../data/services/task_service.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final PetService _petService = PetService();
  final TaskService _taskService = TaskService();

  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool? showCompleted;
  Future<Map<String, dynamic>>? _petsWithTasksFuture;

  @override
  void initState() {
    super.initState();
    _loadPetsData();
  }

  void _loadPetsData() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        _petsWithTasksFuture = _petService.getPetsWithTasks(user.uid);
      });
    } else {
      print('User is not logged in or UID is empty');
    }
  }

  List<Map<String, dynamic>> _getFilteredTasks(
      List<Map<String, dynamic>> tasks) {
    String selectedDayString =
        '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}';

    List<Map<String, dynamic>> tasksForDay = tasks
        .where((task) => task['due_date'].startsWith(selectedDayString))
        .toList();

    if (showCompleted == true) {
      return tasksForDay.where((task) => task['isCompleted']).toList();
    } else if (showCompleted == false) {
      return tasksForDay.where((task) => !task['isCompleted']).toList();
    }
    return tasksForDay;
  }

  String _formatDueDate(String? dueDateString) {
    String dueDate = 'No due date';
    if (dueDateString != null) {
      try {
        DateTime dueDateTime = DateTime.parse(dueDateString);
        dueDate = DateFormat('yyyy-MM-dd – hh:mm a').format(dueDateTime);
      } catch (e) {
        print('Error parsing due_date: $e');
      }
    }
    return dueDate;
  }

  Future<void> _updateTaskStatus(String taskId, bool isCompleted) async {
    try {
      await _taskService.updateTask(id: taskId, isCompleted: isCompleted);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                isCompleted ? 'Task completed' : 'Task marked as in progress')),
      );

      _loadPetsData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1EC),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Tasks'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: _calendarFormat,
            availableCalendarFormats: {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF333333),
              ),
              leftChevronIcon:
                  const Icon(Icons.chevron_left, color: Color(0xFF333333)),
              rightChevronIcon:
                  const Icon(Icons.chevron_right, color: Color(0xFF333333)),
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterButtons(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.calendar_month,
                        size: 30, color: Color(0xFF7B3A10)),
                    SizedBox(width: 10),
                    Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B3A10),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/tasks/addPetTask');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B3A10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: _petsWithTasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError ||
                      (snapshot.data?.containsKey('error') ?? false)) {
                    // return Center(
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.error_outline,
                          //     size: 50, color: Colors.red),
                          // const SizedBox(height: 16),
                          // Text(
                          //   snapshot.data?['error'] ?? 'Something went wrong!',
                          //   style: const TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.red,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          Text(
                            'No tasks available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7B3A10),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tasks available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B3A10),
                        ),
                      ),
                    );
                  }

                  final petsWithTasks = snapshot.data!['pets'] as List<dynamic>;
                  final allTasks = petsWithTasks
                      .expand((pet) => pet['tasks'] as List<dynamic>)
                      .cast<Map<String, dynamic>>()
                      .toList();

                  final filteredTasks = _getFilteredTasks(allTasks);

                  return filteredTasks.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            final pet = petsWithTasks.firstWhere(
                                (pet) => pet['tasks'].contains(task));

                            Color backgroundColor = task['isCompleted']
                                ? const Color(0xFFB2E0B5)
                                : const Color(0xFFFDD7A9);

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: const Color(0xFFFFF1EC),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  task['title'] ?? 'No Title',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pet['name'] ?? 'Unknown Pet'),
                                    Text(_formatDueDate(task['due_date'])),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'view') {
                                      context.go(
                                          '/tasks/taskDetail/${task['id']}/${pet['id']}');
                                    } else if (value == 'complete') {
                                      await _updateTaskStatus(task['id'], true);
                                    } else if (value == 'inprogress') {
                                      await _updateTaskStatus(
                                          task['id'], false);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'view',
                                      child: Text('View Detail'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'complete',
                                      child: Text('Mark as Completed'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'inprogress',
                                      child: Text('Mark as In Progress'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No tasks found for the selected date',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton('All', null),
          _buildFilterButton('Completed', true),
          _buildFilterButton('In Progress', false),
        ],
      ),
    );
  }

  ElevatedButton _buildFilterButton(String label, bool? filterValue) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          showCompleted = filterValue;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: showCompleted == filterValue
            ? const Color(0xFF7B3A10)
            : const Color(0xFFFFF1EC),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: showCompleted == filterValue
              ? Colors.white
              : const Color(0xFF7B3A10),
        ),
      ),
    );
  }
}

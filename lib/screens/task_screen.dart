import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/bottom_navbar.dart';
import '../components/header.dart';
import '../data/dummy_data.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  int currentIndex = 2;

  List<Task> _getTasksForSelectedDay() {
    return pets
        .expand((pet) => pet.tasks)
        .where((task) => task.time.startsWith(
            '${_selectedDay.day.toString().padLeft(2, '0')}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.year}'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95.0),
        child: const CustomHeader(title: 'Pet Notes'),
      ),
      body: SingleChildScrollView(
        // Wrap body in SingleChildScrollView
        child: Column(
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
            ),
            const SizedBox(
                height: 16), // Add space between the calendar and tasks
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tasks',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      // Functionality to add a task can be added here
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Wrap the ListView in a Container with limited height to avoid overflow
            Container(
              height: MediaQuery.of(context).size.height *
                  0.5, // Set height to half the screen
              child: ListView(
                children: _getTasksForSelectedDay().map((task) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: ListTile(
                      leading: Icon(
                        Icons.task_alt,
                        color: task.status ? Colors.green : Colors.red,
                      ),
                      title: Text(task.title),
                      subtitle: Text(task.time),
                      trailing: Text(
                        pets.firstWhere((pet) => pet.tasks.contains(task)).name,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'main_page.dart'; // Import Pet dan Task model

class TaskPage extends StatefulWidget {
  final List<Pet> pets;

  const TaskPage({super.key, required this.pets});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Task> _getTasksForSelectedDay() {
    return widget.pets
        .expand((pet) => pet.tasks)
        .where((task) => task.time.startsWith(
            '${_selectedDay.day.toString().padLeft(2, '0')}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.year}'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F4F4), // Set background color to #f4f4f4
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
          ),
          Expanded(
            child: ListView(
              children: _getTasksForSelectedDay().map((task) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.task_alt,
                      color: task.status == TaskStatus.completed
                          ? Colors.green
                          : task.status == TaskStatus.missed
                              ? Colors.red
                              : Colors.orange,
                    ),
                    title: Text(task.title),
                    subtitle: Text(task.time),
                    trailing: Text(widget.pets
                        .firstWhere((pet) => pet.tasks.contains(task))
                        .name),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

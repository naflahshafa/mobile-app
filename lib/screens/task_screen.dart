import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/bottom_navbar.dart';
import '../components/header.dart';
import '../data/dummy_data.dart';
import 'add_pet_task_screen.dart';
import 'pet_task_detail_screen.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  int currentIndex = 2;
  bool? showCompleted;

  // Filtered list of tasks based on selected day and status filter
  List<Task> _getFilteredTasks() {
    String selectedDayString =
        '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}';

    List<Task> tasksForDay = pets
        .expand((pet) => pet.tasks)
        .where((task) => task.time.startsWith(selectedDayString))
        .toList();

    if (showCompleted == true) {
      return tasksForDay.where((task) => task.status).toList();
    } else if (showCompleted == false) {
      return tasksForDay.where((task) => !task.status).toList();
    }
    return tasksForDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Pet Notes'),
      ),
      body: Column(
        children: [
          // Calendar section (fixed)
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
            // Customizing calendar's header style
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue
                    .withOpacity(0.3), // Today's date with transparent blue
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue
                    .withOpacity(0.5), // Selected date color with transparency
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              weekendDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              outsideDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true, // Show format button
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, // Bold month and year text
                fontSize: 20,
                color: Color(0xFF333333), // Month and year color
              ),
              leftChevronIcon:
                  const Icon(Icons.chevron_left, color: Color(0xFF333333)),
              rightChevronIcon:
                  const Icon(Icons.chevron_right, color: Color(0xFF333333)),
            ),
          ),
          const SizedBox(height: 16),

          // Filter buttons (completed and missed) (fixed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                // "All" button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCompleted = null; // Show all tasks
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showCompleted == null
                        ? const Color(0xFF333333)
                        : Colors.white,
                  ),
                  child: Text(
                    'All',
                    style: TextStyle(
                      color: showCompleted == null
                          ? Colors.white
                          : const Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // "Completed" button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCompleted = true; // Show completed tasks
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showCompleted == true
                        ? const Color(0xFF333333)
                        : Colors.white,
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      color: showCompleted == true
                          ? Colors.white
                          : const Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // "Missed" button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCompleted = false; // Show missed tasks
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showCompleted == false
                        ? const Color(0xFF333333)
                        : Colors.white,
                  ),
                  child: Text(
                    'Missed',
                    style: TextStyle(
                      color: showCompleted == false
                          ? Colors.white
                          : const Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Task header and Add Task button (fixed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.calendar_month,
                        size: 30, color: Color(0xFF333333)),
                    SizedBox(width: 10),
                    Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPetTaskScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Add Task',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Task list (scrollable)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _getFilteredTasks().isNotEmpty
                  ? ListView.builder(
                      itemCount: _getFilteredTasks().length,
                      itemBuilder: (context, index) {
                        Task task = _getFilteredTasks()[index];
                        String petName = pets
                            .firstWhere((pet) => pet.tasks.contains(task))
                            .name;

                        // Define the background color based on the task status
                        Color backgroundColor = task.status
                            ? const Color(
                                0xFFB2E0B5) // Completed: Greenish background
                            : const Color(
                                0xFFFDD7A9); // Incomplete: Orangish background

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4), // Margin for spacing
                          color: const Color(
                              0xFFFFFFFF), // Set card background to white
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
                            title: Text(task.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(petName), // Pet name displayed here
                                Text(task.time), // Task time displayed below
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'view') {
                                  // Find the corresponding pet for the task
                                  Pet pet = pets.firstWhere(
                                      (pet) => pet.tasks.contains(task));

                                  // Navigate to PetTaskDetailPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PetTaskDetailPage(
                                        task: task, // Pass the selected task
                                        pet: pet, // Pass the found pet object
                                      ),
                                    ),
                                  );
                                } else if (value == 'complete') {
                                  // Implement mark as completed functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${task.title} marked as completed'),
                                    ),
                                  );
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
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No tasks for this day',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
            ),
          ),
        ],
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

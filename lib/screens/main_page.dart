import 'package:flutter/material.dart';
import 'pet_screen.dart';
import 'task_screen.dart';
import 'settings_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPage> {
  final String userName = "User";
  final List<Pet> pets = [
    Pet(
      name: "Mochi",
      type: "Dog",
      tasks: [
        Task(
            title: "Walk",
            time: "01-10-2024 08:00 AM",
            status: TaskStatus.completed),
        Task(
            title: "Feed",
            time: "01-10-2024 09:00 AM",
            status: TaskStatus.pending),
      ],
      imageUrl: null,
    ),
    Pet(
      name: "Milo",
      type: "Cat",
      tasks: [
        Task(
            title: "Play",
            time: "01-10-2024 04:00 PM",
            status: TaskStatus.missed),
        Task(
            title: "Vet Appointment",
            time: "01-10-2024 10:00 AM",
            status: TaskStatus.pending),
      ],
      imageUrl:
          "https://ik.imagekit.io/ggslopv3t/red-white-cat-i-white-studio-cut.jpg?updatedAt=1728912159893",
    ),
    Pet(
      name: "Miko",
      type: "Rabbit",
      tasks: [],
      imageUrl: null,
    ),
  ];

  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      MainContent(pets: pets),
      const PetPage(),
      TaskPage(pets: pets),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedLabelStyle: TextStyle(fontSize: 12),
          selectedLabelStyle:
              TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(95.0),
          child: Container(
            height: 95.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'Pet Notes',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 75.0,
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFFFFFFFF),
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? const Color(0xFF333333)
                      : const Color(0xFFD7D7D7),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.pets,
                  color: _selectedIndex == 1
                      ? const Color(0xFF333333)
                      : const Color(0xFFD7D7D7),
                ),
                label: 'Pets',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month,
                  color: _selectedIndex == 2
                      ? const Color(0xFF333333)
                      : const Color(0xFFD7D7D7),
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: _selectedIndex == 3
                      ? const Color(0xFF333333)
                      : const Color(0xFFD7D7D7),
                ),
                label: 'Settings',
              ),
            ],
            selectedItemColor: const Color(0xFF333333),
            unselectedItemColor: const Color(0xFFD7D7D7),
            type: BottomNavigationBarType.fixed,
          ),
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  final List<Pet> pets;

  const MainContent({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F4F4),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 15),
          Expanded(child: _buildPetsList(pets, context)), // Pass context here
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String todayDate = '${DateTime.now().day} ${[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][DateTime.now().month - 1]} ${DateTime.now().year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hello, User!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(todayDate,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildPetsList(List<Pet> pets, BuildContext context) {
    // Accept context
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return _buildPetCard(pets[index], context); // Pass context to pet card
      },
    );
  }

  Widget _buildPetCard(Pet pet, BuildContext context) {
    // Accept context
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // borderRadius: BorderRadius.circular(
                    //     8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      pet.imageUrl?.isNotEmpty == true
                          ? pet.imageUrl!
                          : 'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors
                              .grey,
                          child: const Icon(Icons.error,
                              color: Colors.red),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pet.type,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            _buildTasksList(pet.tasks, context), // Pass context
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<Task> tasks, BuildContext context) {
    // Accept context
    if (tasks.isEmpty) {
      return const Text('No tasks available.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasks
          .map((task) => _buildTaskCard(task, context))
          .toList(), // Pass context
    );
  }

  Widget _buildTaskCard(Task task, BuildContext context) {
    // Accept context
    Color backgroundColor;
    switch (task.status) {
      case TaskStatus.completed:
        backgroundColor =
            const Color(0xFFB2E0B5);
        break;
      case TaskStatus.missed:
        backgroundColor = const Color(0xFFFDD7A9);
        break;
      case TaskStatus.pending:
      default:
        backgroundColor = const Color(0xFFFFF393);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8), // Geser ikon sedikit ke kanan
          Container(
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            padding: const EdgeInsets.only(right: 8),
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              // if (value == 'Edit') {
              //   _editTask(context, task); // Pass context
              // } else if (value == 'Delete') {
              //   _deleteTask(context, task); // Pass context
              // }
              if (value == 'Status') {
                _editTask(context, task); // Pass context
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'Status', child: Text('Mark as Completed')),
              // const PopupMenuItem(value: 'Delete', child: Text('Delete Task')),
            ],
          ),
        ],
      ),
    );
  }

  void _editTask(BuildContext context, Task task) {
    // Accept context
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mark as Completed ${task.title}')),
    );
  }

  // void _deleteTask(BuildContext context, Task task) {
  //   // Accept context
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Deleted ${task.title}')),
  //   );
  // }
}

class Pet {
  final String name;
  final String type;
  final List<Task> tasks;
  final String? imageUrl;

  Pet(
      {required this.name,
      required this.type,
      required this.tasks,
      this.imageUrl});
}

class Task {
  final String title;
  final String time;
  final TaskStatus status;

  Task({required this.title, required this.time, required this.status});
}

enum TaskStatus { completed, pending, missed }

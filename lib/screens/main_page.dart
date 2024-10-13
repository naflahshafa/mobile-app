import 'package:flutter/material.dart';
import 'pet_screen.dart'; // Import halaman Pet
import 'task_screen.dart'; // Import halaman Tasks
import 'settings_screen.dart'; // Import halaman Settings

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPage> {
  final String userName = "User"; // Ganti dengan nama pengguna yang sesuai
  final List<Pet> pets = [
    Pet(
      name: "Mochi",
      type: "Dog",
      tasks: [
        Task(title: "Walk", time: "08:00 AM", status: TaskStatus.completed),
        Task(title: "Feed", time: "09:00 AM", status: TaskStatus.pending),
      ],
    ),
    Pet(
      name: "Milo",
      type: "Cat",
      tasks: [
        Task(title: "Play", time: "04:00 PM", status: TaskStatus.missed),
        Task(
            title: "Vet Appointment",
            time: "10:00 AM",
            status: TaskStatus.pending),
      ],
    ),
    Pet(
      name: "Miko",
      type: "Rabbit",
      tasks: [],
    ),
  ];

  int _selectedIndex = 0;
  late List<Widget> _pages; // Use late keyword to declare the variable

  @override
  void initState() {
    super.initState();
    // Initialize _pages here
    _pages = [
      MainContent(pets: pets), // Pass the pets list to MainContent
      const PetPage(),
      const TaskPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pet Notes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600, // Semi-bold
            color: Colors.white, // Teks berwarna putih
          ),
        ),
        centerTitle: true, // Agar judul berada di tengah
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlue
              ], // Gradasi warna biru
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index; // Ubah indeks yang dipilih
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'Pets'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: _pages[
          _selectedIndex], // Tampilkan halaman sesuai dengan indeks yang dipilih
    );
  }
}

// Widget terpisah untuk konten utama
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
          const SizedBox(height: 20),
          Expanded(child: _buildPetsList(pets)),
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
        const Text(
          'Hello, User!', // Replace with dynamic user name if needed
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          todayDate,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPetsList(List<Pet> pets) {
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return _buildPetCard(pets[index]);
      },
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pets, size: 40),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(pet.type, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTasksList(pet.tasks), // Display tasks for each pet
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Text('No tasks available', style: TextStyle(color: Colors.grey));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var task in tasks) _buildTaskCard(task),
      ],
    );
  }

  Widget _buildTaskCard(Task task) {
    Color backgroundColor;
    switch (task.status) {
      case TaskStatus.completed:
        backgroundColor = const Color(0xFFBBD4E7); // Warna untuk status completed
        break;
      case TaskStatus.missed:
        backgroundColor = const Color(0xFFFDD7A9); // Warna untuk status missed
        break;
      case TaskStatus.pending:
      default:
        backgroundColor = const Color(0xFFFFF393); // Warna untuk status pending
        break;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(12.0),
      width: double.infinity, // Mengatur lebar penuh
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title,
              style:
                  const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), // Ruang antara judul dan waktu
          Text(task.time, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}

class Pet {
  final String name;
  final String type;
  final List<Task> tasks; // Add tasks to Pet

  Pet({required this.name, required this.type, required this.tasks});
}

class Task {
  final String title;
  final String time;
  final TaskStatus status;

  Task({required this.title, required this.time, required this.status});
}

enum TaskStatus { completed, pending, missed }

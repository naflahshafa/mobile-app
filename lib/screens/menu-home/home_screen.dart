import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../menu-pets/add_pet_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(135.0),
        child: _buildCustomHeader(),
      ),
      body: _buildMainContent(context),
    );
  }

  Widget _buildCustomHeader() {
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

    return Container(
      padding: const EdgeInsets.only(
          top: 36.0, left: 16.0, right: 16.0, bottom: 16.0),
      color: const Color(0xFF4B2FB8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $userName!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC443),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage your pet’s notes and tasks easily!',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFFFC443),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            todayDate,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFD7D7D7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    if (pets.isEmpty) {
      return _buildEmptyPetScreen(context);
    }

    return Container(
      color: const Color(0xFF4B2FB8),
      padding: const EdgeInsets.only(
          top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Expanded(child: _buildPetsList(context)),
        ],
      ),
    );
  }

  Widget _buildEmptyPetScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No pet available',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Please add a pet first.',
            style: TextStyle(fontSize: 16, color: Color(0xFFD7D7D7)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPetScreen()),
              );
            },
            child: Text('Add Pet'),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsList(BuildContext context) {
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return _buildPetCard(context, pets[index]);
      },
    );
  }

  Widget _buildPetCard(BuildContext context, Pet pet) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFFFFC443),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              image: DecorationImage(
                image: NetworkImage(
                  pet.imageUrl?.isNotEmpty == true
                      ? pet.imageUrl!
                      : 'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1730823417444',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          pet.type,
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildTasksList(context, pet.tasks),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Text('No tasks available.',
          style: TextStyle(color: Color(0xFFD7D7D7), fontSize: 12));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasks.map((task) => _buildTaskCard(task, context)).toList(),
    );
  }

  Widget _buildTaskCard(Task task, BuildContext context) {
    Color backgroundColor =
        task.status ? const Color(0xFFB2E0B5) : const Color(0xFFFDD7A9);

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFFFC443),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.calendar_month, color: Color(0xFF333333)),
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
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.time,
                  style:
                      const TextStyle(color: Color(0xFF333333), fontSize: 12),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            padding: const EdgeInsets.only(right: 6),
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF333333),
            ),
            onSelected: (value) {
              if (value == 'Status') {
                _editTaskStatus(context, task);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Status',
                child: Text('Mark as Completed'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editTaskStatus(BuildContext context, Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mark as Completed: ${task.title}')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/pet_service.dart';
import '../../data/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PetService _petService = PetService();
  final UserService _userService = UserService();
  List<Map<String, dynamic>> pets = [];
  bool _isLoading = true;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadPetsData();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.getUserData();
      if (userData != null) {
        setState(() {
          _username = userData.username;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _loadPetsData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.uid.isNotEmpty) {
      String userUid = user.uid;
      // print('User UID from home page: $userUid');
      try {
        final data = await _petService.getPetsWithTasks(userUid);
        setState(() {
          pets = List<Map<String, dynamic>>.from(data['pets']);
          _isLoading = false;
        });

        // print('Pets loaded (home screen): $pets');
      } catch (error) {
        print('Error fetching pets: $error');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('User is not logged in or UID is empty');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      color: const Color(0xFF7B3A10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${_username.isNotEmpty ? _username : 'User'}!',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF4F4F4)),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage your pet’s notes and tasks easily!',
            style: const TextStyle(fontSize: 16, color: Color(0xFFF4F4F4)),
          ),
          const SizedBox(height: 4),
          Text(
            todayDate,
            style: const TextStyle(fontSize: 12, color: Color(0xFFF4F4F4)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }
    if (pets.isEmpty) {
      return _buildEmptyPetScreen(context);
    }

    return Container(
      color: const Color(0xFF7B3A10),
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

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
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
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.go('/pets/addPet');
            },
            child: Text('Add Pet'),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsList(BuildContext context) {
    // print('Building pet list (home screen): $pets');
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return _buildPetCard(context, pets[index]);
      },
    );
  }

  Widget _buildPetCard(BuildContext context, Map<String, dynamic> petData) {
    var petName = petData['name'] ?? 'No name'; // Use fallback if name is null
    var animalCategoryName = petData['animal_category'] ?? 'Unknown';
    var imageUrl = petData['image_profile'] ??
        'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1730823417444';
    var tasks = petData['tasks'] is List ? petData['tasks'] : [];

    // print('Pet Name: $petName');
    // print('Tasks: $tasks');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
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
                image: NetworkImage(imageUrl),
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
                          petName,
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          animalCategoryName,
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
                _buildTasksList(context, tasks),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, List<dynamic> tasks) {
    if (tasks.isEmpty) {
      return const Text('No tasks available.',
          style: TextStyle(color: Colors.grey, fontSize: 12));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasks.map((task) => _buildTaskCard(task, context)).toList(),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, BuildContext context) {
    String taskTitle = task['title'] ?? 'No title';
    String dueDate = 'No due date';
    if (task['due_date'] != null) {
      DateTime dueDateTime =
          DateTime.parse(task['due_date']); // Convert string to DateTime
      dueDate = DateFormat('yyyy-MM-dd – hh:mm a')
          .format(dueDateTime); // Format: 2024-11-22 – 02:30 PM
    }
    bool isCompleted = task['isCompleted'] ?? false;
    Color backgroundColor =
        isCompleted ? const Color(0xFFB2E0B5) : const Color(0xFFFDD7A9);

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
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
                  taskTitle,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dueDate,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

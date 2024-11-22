import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/header.dart';
import 'notes/pet_notes_screen.dart';
import 'vaccine/pet_vaccine_screen.dart';
import '../../data/services/pet_service.dart';
import '../../data/models/pet_model.dart';

enum PetView { list, notes, vaccine }

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  @override
  _PetPageState createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  PetView currentView = PetView.list;
  final PetService _petService = PetService();
  List<Pet> pets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final loadedPets = await _petService.getAllPetsByUserUid();
      setState(() {
        pets = loadedPets;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading pets: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF7B3A10),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(95.0),
          child: const CustomHeader(title: 'Pets'),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          child: TabBar(
            onTap: (index) {
              setState(() {
                currentView = PetView.values[index];
              });
            },
            labelColor: const Color(0xFFFFF1EC),
            unselectedLabelColor: const Color(0xFFC28460),
            indicatorColor: const Color(0xFFFFF1EC),
            tabs: const [
              Tab(text: 'List'),
              Tab(text: 'Notes'),
              Tab(text: 'Vaccine'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              _buildPetListView(),
              PetNotesScreen(),
              PetVaccineScreen(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPetListView() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pets.isEmpty) {
      return _buildEmptyPetScreen();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(child: _buildPetList(context)),
      ],
    );
  }

  Widget _buildEmptyPetScreen() {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No pet data available',
                  style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xFFFFF1EC),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Please add a pet first.',
                  style:
                      TextStyle(fontSize: 16, color: const Color(0xFFFFF1EC)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, right: 20.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.pets, size: 30, color: Color(0xFFFFF1EC)),
              const SizedBox(width: 10),
              const Text(
                'My Pets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFF1EC),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1EC),
              borderRadius: BorderRadius.all(Radius.circular(45)),
            ),
            child: ElevatedButton(
              onPressed: () {
                context.go('/pets/addPet');
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.transparent,
              ),
              child: const Text(
                'Add Pet',
                style: TextStyle(color: Color(0xFF7B3A10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetList(BuildContext context) {
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return _buildPetCard(context, pets[index]);
      },
    );
  }

  Widget _buildPetCard(BuildContext context, Pet pet) {
    return GestureDetector(
      onTap: () {
        context.go('/pets/profile/${pet.id}');
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    pet.imageProfile.isNotEmpty
                        ? pet.imageProfile
                        : 'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF333333),
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15),
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
                    pet.animalCategory,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

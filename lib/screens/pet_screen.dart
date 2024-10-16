import 'package:flutter/material.dart';
import '../components/bottom_navbar.dart';
import '../components/header.dart';
import '../data/dummy_data.dart';
import 'pet_profile_screen.dart';
import 'pet_notes_screen.dart';

enum PetView { list, profile, notes } // Tambahkan enum untuk tracking tampilan

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  @override
  _PetPageState createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  int currentIndex = 1; // Set the initial index for the bottom nav
  PetView currentView = PetView.list; // Tampilan default adalah list
  Pet? selectedPet; // Simpan pet yang dipilih untuk profile/notes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Background color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95.0),
        child: const CustomHeader(title: 'Pet Notes'), // Gunakan CustomHeader
      ),
      body: _buildBody(), // Ganti dengan widget dinamis
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index; // Update the current index
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (currentView) {
      case PetView.profile:
        return PetProfileScreen(pet: selectedPet!); // Tampilkan profile
      case PetView.notes:
        return PetNotesScreen(pet: selectedPet!); // Tampilkan notes
      case PetView.list:
      default:
        return _buildPetListView(); // Tampilkan list default
    }
  }

  Widget _buildPetListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 15),
        Expanded(child: _buildPetList(context)), // Pet list
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.pets, size: 30, color: Color(0xFF333333)),
              const SizedBox(width: 10),
              const Text(
                'My Pets',
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
                // Tambahkan logika add pet di sini
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.transparent,
              ),
              child: const Text(
                'Add Pet',
                style: TextStyle(color: Colors.white),
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
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
                          color: Colors.grey,
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
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      pet.type,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Color(0xFF333333)),
              onSelected: (String value) {
                if (value == 'View Pet Profile') {
                  _navigateToProfile(pet);
                } else if (value == 'View Pet Notes') {
                  _navigateToNotes(pet);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'View Pet Profile',
                    child: Text('View Pet Profile'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'View Pet Notes',
                    child: Text('View Pet Notes'),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProfile(Pet pet) {
    setState(() {
      currentView = PetView.profile;
      selectedPet = pet;
    });
  }

  void _navigateToNotes(Pet pet) {
    setState(() {
      currentView = PetView.notes;
      selectedPet = pet;
    });
  }
}

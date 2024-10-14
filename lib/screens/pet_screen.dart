import 'package:flutter/material.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F4F4), // Mengatur warna latar belakang
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context), // Memanggil header
          const SizedBox(height: 15),
          Expanded(child: _buildPetList(context)), // Memanggil daftar kartu pet
        ],
      ),
    );
  }

  // Membuat header
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
              borderRadius: BorderRadius.all(
                  Radius.circular(45)), // Pastikan sudut tombol melengkung
            ),
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan logika add pet di sini
              },
              style: ElevatedButton.styleFrom(
                elevation:
                    0, // Hilangkan bayangan untuk tampilan gradasi yang lebih halus
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                minimumSize:
                    const Size(100, 15), // Mengatur ukuran minimum tombol
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
    // Daftar dummy untuk kartu hewan peliharaan
    final List<Pet> pets = [
      Pet(
        name: "Mochi",
        type: "Dog",
        imageUrl: null,
      ),
      Pet(
        name: "Milo",
        type: "Cat",
        imageUrl:
            "https://ik.imagekit.io/ggslopv3t/red-white-cat-i-white-studio-cut.jpg?updatedAt=1728912159893",
      ),
      Pet(
        name: "Miko",
        type: "Rabbit",
        imageUrl: null,
      ),
    ];

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
            // Ikon opsi
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Color(0xFF333333)),
              onSelected: (String value) {
                if (value == 'View Pet Profile') {
                  // Navigasi ke halaman profil hewan peliharaan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetProfileScreen(pet: pet),
                    ),
                  );
                } else if (value == 'View Pet Notes') {
                  // Navigasi ke halaman catatan hewan peliharaan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetNotesScreen(pet: pet),
                    ),
                  );
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
}

class Pet {
  final String name;
  final String type;
  final String? imageUrl;

  Pet({required this.name, required this.type, this.imageUrl});
}

// Halaman Profil Hewan Peliharaan
class PetProfileScreen extends StatelessWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${pet.name} Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile of ${pet.name}', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            // Tambahkan detail lainnya di sini
            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text('Type: ${pet.type}', style: TextStyle(fontSize: 18)),
                    // Tambahkan informasi lain jika perlu
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Catatan Hewan Peliharaan
class PetNotesScreen extends StatelessWidget {
  final Pet pet;

  const PetNotesScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes for ${pet.name}')),
      body: Center(
        child: Text('Notes for ${pet.name}'),
      ),
    );
  }
}

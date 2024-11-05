import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import 'pet_screen.dart';
import 'pet_note_detail_screen.dart';
import 'add_pet_note_screen.dart';

class PetNotesScreen extends StatelessWidget {
  final Pet pet;

  const PetNotesScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(context), // Tambahkan tombol back
            const SizedBox(height: 10),
            _buildHeader(context, pet),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: pet.notes.length,
                  itemBuilder: (context, index) {
                    return _buildNoteCard(context, pet.notes[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
      label: const Text(
        'Back',
        style: TextStyle(color: Color(0xFF333333)), // Mengatur warna teks
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PetPage()),
        ); // Kembali ke halaman sebelumnya
      },
    );
  }

  Widget _buildHeader(BuildContext context, Pet pet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.notes, size: 30, color: Color(0xFF333333)),
              const SizedBox(width: 10),
              Text(
                "${pet.name}'s Notes", // Display pet's name in the header
                style: const TextStyle(
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
                    builder: (context) => AddPetNoteScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.transparent,
              ),
              child: const Text(
                'Add Note',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding:
            const EdgeInsets.all(8.0), // Add some padding for better spacing
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align contents to start
          children: [
            ListTile(
              title: Text(note.title),
              subtitle: _buildNoteDescription(note.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigasi ke NoteDetailPage dengan mengirimkan objek note dan pet
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(
                    note: note, // Mengirim objek note
                    pet: pet, // Mengirim objek pet yang sesuai
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteDescription(String description) {
    const int wordLimit = 20; // Batasi 20 kata
    final words = description.split(' ');

    if (words.length <= wordLimit) {
      return Text(description);
    } else {
      String truncatedDescription = words.take(wordLimit).join(' ') + '...';
      return Row(
        children: [
          Expanded(
            child: Text(truncatedDescription),
          ),
        ],
      );
    }
  }
}

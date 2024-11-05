import 'package:flutter/material.dart';
import '../../components/bottom_navbar.dart';
import '../../components/header.dart';
import '../../data/dummy_data.dart'; // Pastikan untuk mengimpor file data yang sesuai
import 'edit_pet_note_screen.dart'; // Import the EditPetNoteScreen

class NoteDetailPage extends StatefulWidget {
  final Note note;
  final Pet pet; // Menambahkan pet ke constructor

  const NoteDetailPage({super.key, required this.note, required this.pet});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  int currentIndex = 1; // Set default index for BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Pet Notes'), // Menggunakan CustomHeader
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Mengatur alignment ke kiri
        children: [
          Container(
            margin: const EdgeInsets.all(10), // Menambahkan margin untuk tombol
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
              label: const Text(
                'Back',
                style:
                    TextStyle(color: Color(0xFF333333)), // Mengatur warna teks
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
            ),
          ),
          const SizedBox(height: 10), // Jarak antara tombol Back dan Card

          Expanded(
            child: SingleChildScrollView(
              // Menambahkan ScrollView
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Mengubah alignment ke kiri
                    children: [
                      const SizedBox(height: 20),
                      // Title Note
                      Text(
                        widget.note.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Nama Pemilik Note (Nama Pet)
                      Row(
                        children: [
                          const Icon(Icons.pets),
                          const SizedBox(width: 8),
                          Text(
                            widget
                                .pet.name, // Mengambil nama pet dari objek pet
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Isi Note
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align the icon and text at the start
                        children: [
                          const Icon(Icons.notes),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.note.description,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      // Tanggal Note (Jika ada, Anda dapat menambahkan logika untuk mendapatkan tanggal)
                      const Text(
                        "2024-10-02 7:00 PM", // Anda bisa menambahkan logika dinamis di sini
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      // Tombol Edit Note
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 45), // Lebar penuh
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to the EditPetNoteScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPetNoteScreen(
                                note: widget.note,
                              ),
                            ),
                          ).then((updatedNote) {
                            if (updatedNote != null) {
                              // Handle the updated note here if needed
                            }
                          });
                        },
                        child: const Text('Edit Note'),
                      ),
                      const SizedBox(height: 10),
                      // Tombol Delete Note
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Aksi delete note
                        },
                        child: const Text('Delete Note'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
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
            currentIndex = index; // Update the current index when tapped
          });
        },
      ),
    );
  }
}

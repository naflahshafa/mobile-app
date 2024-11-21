import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'edit_pet_note_screen.dart';
import '../../../components/header.dart';
import '../../../data/dummy_data.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;
  final Pet pet;

  const NoteDetailPage({super.key, required this.note, required this.pet});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Detail Pet Note'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFF4F4F4)),
              label: const Text(
                'Back',
                style: TextStyle(color: Color(0xFFF4F4F4)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
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
                        CrossAxisAlignment.start, // Atur alignment ke kiri
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
                      Row(
                        children: [
                          const Icon(Icons.pets),
                          const SizedBox(width: 8),
                          Text(
                            widget.pet.name,
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
                      // Tanggal Note (Tambahkan logika untuk mendapatkan tanggal)
                      const Text(
                        "2024-10-02 7:00 PM", // Tambahkan logika dinamis di sini
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
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
                        // onPressed: () {
                        //   context.go('/pets/noteDetail/editPetNote',
                        //       extra: widget.note);
                        // },
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
    );
  }
}

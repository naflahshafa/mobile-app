import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../components/header.dart';
import '../../../data/services/note_service.dart';
import '../../../data/models/note_model.dart';

class NoteDetailPage extends StatelessWidget {
  final String noteId;
  final String petUid;

  const NoteDetailPage({super.key, required this.noteId, required this.petUid});

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Detail Pet Note'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: NoteService().getNoteAndPetNameByIdAndPetUid(noteId, petUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No data available"));
          }

          final noteData = snapshot.data!;
          final note = Note.fromMap(noteData['note'], noteId);
          final petName = noteData['pet_name'];
          final createdAt = note.createdAt != null
              ? formatDateTime(note.createdAt!)
              : 'Unknown Date';

          return _buildNoteDetailView(context, note, petName, createdAt);
        },
      ),
    );
  }

  Widget _buildNoteDetailView(
      BuildContext context, Note note, String petName, String createdAt) {
    return Column(
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
              context.go('/pets', extra: {'tabIndex': 1});
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      note.title,
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
                          petName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.category),
                        const SizedBox(width: 8),
                        Text(
                          note.noteCategory,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note.description,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      createdAt,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context
                            .go('/pets/noteDetail/$noteId/$petUid/editPetNote');
                      },
                      child: const Text('Edit Note'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        bool confirmed = await _showConfirmationDialog(context);
                        if (confirmed) {
                          await NoteService().deleteNote(noteId);
                          _showSuccessDialog(context);
                        }
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
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Note'),
              content: const Text('Are you sure you want to delete this note?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Note deleted successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/pets', extra: {'tabIndex': 1});
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

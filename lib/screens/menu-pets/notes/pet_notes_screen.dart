import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/pet_service.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/models/note_model.dart';

class PetNotesScreen extends StatefulWidget {
  const PetNotesScreen({super.key});

  @override
  _PetNotesScreenState createState() => _PetNotesScreenState();
}

class _PetNotesScreenState extends State<PetNotesScreen> {
  final PetService _petService = PetService();
  List<Map<String, dynamic>> petsAndNotes = [];
  Pet? selectedPet;
  bool isLoading = true;
  bool isFirstLoad = true; // Flag untuk kontrol loading saat pertama kali

  @override
  void initState() {
    super.initState();
    _fetchPetsWithNotes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isFirstLoad) {
      _fetchPetsWithNotes(); // Muat ulang data saat screen muncul kembali
    }
    isFirstLoad = false; // Ubah flag setelah load pertama selesai
  }

  Future<void> _fetchPetsWithNotes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await _petService.getPetsWithNotesByUserUid();
      // print('Pets and Notes Data (pet notes screen): $data');
      setState(() {
        petsAndNotes = data;
        isLoading = false;
      });

      // print(
      //     'Updated pets and notes in state (pet notes screen): $petsAndNotes');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching pets and notes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B3A10),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            _buildHeader(context),
            const SizedBox(height: 10),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildPetSelectionDropdown(),
            const SizedBox(height: 10),
            if (!isLoading && selectedPet != null)
              Expanded(
                child: _buildNotesListView(selectedPet!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.notes, size: 30, color: Color(0xFFFFF1EC)),
              SizedBox(width: 10),
              Text(
                "Pet Notes",
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
                context.go('/pets/addPetNote');
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.transparent,
              ),
              child: const Text(
                'Add Note',
                style: TextStyle(color: Color(0xFF7B3A10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetSelectionDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1EC),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<Pet>(
        value: selectedPet,
        hint: const Text("Select a Pet"),
        isExpanded: true,
        underline: Container(),
        items: petsAndNotes.map<DropdownMenuItem<Pet>>((entry) {
          return DropdownMenuItem<Pet>(
            value: entry['pet'] as Pet,
            child: Text(entry['pet'].name),
          );
        }).toList(),
        onChanged: (Pet? newPet) {
          setState(() {
            selectedPet = newPet;
          });
        },
      ),
    );
  }

  Widget _buildNotesListView(Pet pet) {
    final notes =
        petsAndNotes.firstWhere((entry) => entry['pet'].id == pet.id)['notes']
            as List<Note>;

    if (notes.isEmpty) {
      return _buildEmptyNotesMessage();
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _buildNoteCard(context, notes[index]);
      },
    );
  }

  Widget _buildEmptyNotesMessage() {
    return Center(
      child: Text(
        "No notes available for this pet.",
        style: TextStyle(fontSize: 16, color: const Color(0xFFFFF1EC)),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(note.title),
              subtitle: _buildNoteDescription(note.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (selectedPet != null) {
                  // print(
                  //     'Navigating to NoteDetailPage with Note ID: ${note.id}, Pet UID: ${selectedPet!.id}');
                  context.go(
                    '/pets/noteDetail/${note.id}/${selectedPet!.id}',
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Pet not selected")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteDescription(String description) {
    const int wordLimit = 20;
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

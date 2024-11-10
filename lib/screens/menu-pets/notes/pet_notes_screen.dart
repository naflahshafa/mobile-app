import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/dummy_data.dart';

class PetNotesScreen extends StatefulWidget {
  const PetNotesScreen({super.key});

  @override
  _PetNotesScreenState createState() => _PetNotesScreenState();
}

class _PetNotesScreenState extends State<PetNotesScreen> {
  Pet? selectedPet; // Variable to hold the selected pet

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
            _buildPetSelectionDropdown(),
            const SizedBox(height: 10),
            if (selectedPet != null)
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
              Icon(Icons.notes, size: 30, color: const Color(0xFFFFF1EC)),
              SizedBox(width: 10),
              Text(
                "Pet Notes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFF1EC),
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
        underline: Container(), // Remove the underline
        items: pets.map<DropdownMenuItem<Pet>>((Pet pet) {
          return DropdownMenuItem<Pet>(
            value: pet,
            child: Text(pet.name),
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
    if (pet.notes.isEmpty) {
      return _buildEmptyNotesMessage();
    }

    return ListView.builder(
      itemCount: pet.notes.length,
      itemBuilder: (context, index) {
        return _buildNoteCard(context, pet.notes[index]);
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
                context.go(
                  '/pets/noteDetail',
                  extra: [note, selectedPet],
                );
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

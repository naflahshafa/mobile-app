import 'package:flutter/material.dart';
import '../../../data/dummy_data.dart';
import '../pet_screen.dart';
import '../notes/pet_note_detail_screen.dart';
import '../notes/add_pet_note_screen.dart';

class PetVaccineScreen extends StatefulWidget {
  const PetVaccineScreen({super.key});

  @override
  _PetVaccineScreenState createState() => _PetVaccineScreenState();
}

class _PetVaccineScreenState extends State<PetVaccineScreen> {
  DummyPet? selectedPet; // Variable to hold the selected pet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(context), // Add back button
            const SizedBox(height: 10),
            _buildHeader(context),
            const SizedBox(height: 10),
            _buildPetSelectionDropdown(), // Dropdown to select pet
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

  Widget _buildBackButton(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
      label: const Text(
        'Back',
        style: TextStyle(color: Color(0xFF333333)),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PetPage()),
        ); // Go back to the PetPage
      },
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
              Icon(Icons.notes, size: 30, color: Color(0xFF333333)),
              SizedBox(width: 10),
              Text(
                "Pet's Notes",
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPetNoteScreen()),
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

  Widget _buildPetSelectionDropdown() {
    return DropdownButton<DummyPet>(
      value: selectedPet,
      hint: const Text("Select a Pet"),
      isExpanded: true,
      items: pets.map<DropdownMenuItem<DummyPet>>((DummyPet pet) {
        return DropdownMenuItem<DummyPet>(
          value: pet,
          child: Text(pet.name),
        );
      }).toList(),
      onChanged: (DummyPet? newPet) {
        setState(() {
          selectedPet = newPet;
        });
      },
    );
  }

  Widget _buildNotesListView(DummyPet pet) {
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
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, DummyNote note) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      color: const Color(0xFFFFFFFF),
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(
                    note: note,
                    pet: selectedPet!, // Send selected pet
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
    const int wordLimit = 20; // Limit to 20 words
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

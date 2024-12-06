import 'package:flutter/material.dart';
import '../../components/header.dart';
import '../../data/models/pet_model.dart';
import '../../data/services/pet_service.dart';
import 'list-profile-pet/pet_list_screen.dart';
import 'notes/pet_notes_screen.dart';
// import 'vaccine/pet_vaccine_screen.dart';

enum PetView { list, notes, vaccine }

class PetPage extends StatefulWidget {
  final int? initialTabIndex;

  const PetPage({Key? key, this.initialTabIndex}) : super(key: key);

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
    currentView = PetView.values[widget.initialTabIndex ?? 0];
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
      length: 2,
      initialIndex: widget.initialTabIndex ?? 0,
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
              // Tab(text: 'Vaccine'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              PetListScreen(
                isLoading: isLoading,
                pets: pets,
                reloadPets: _loadPets,
              ),
              const PetNotesScreen(),
              // const PetVaccineScreen(),
            ],
          ),
        ),
      ],
    );
  }
}

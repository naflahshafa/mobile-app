import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/pet_model.dart';

class PetListScreen extends StatelessWidget {
  final bool isLoading;
  final List<Pet> pets;
  final VoidCallback reloadPets;

  const PetListScreen({
    Key? key,
    required this.isLoading,
    required this.pets,
    required this.reloadPets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pets.isEmpty) {
      return _buildEmptyPetScreen(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(child: _buildPetList(context)),
      ],
    );
  }

  Widget _buildEmptyPetScreen(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'No pet data available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFF1EC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please add a pet first.',
                  style: TextStyle(fontSize: 16, color: Color(0xFFFFF1EC)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, right: 20.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.pets, size: 30, color: Color(0xFFFFF1EC)),
              SizedBox(width: 10),
              Text(
                'My Pets',
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
                context.go('/pets/addPet');
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.transparent,
              ),
              child: const Text(
                'Add Pet',
                style: TextStyle(color: Color(0xFF7B3A10)),
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
    return GestureDetector(
      onTap: () {
        context.go('/pets/profile/${pet.id}');
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    pet.imageProfile.isNotEmpty
                        ? pet.imageProfile
                        : 'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF333333),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    pet.animalCategory,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

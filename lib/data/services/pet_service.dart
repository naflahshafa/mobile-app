import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pet_model.dart';
import '../models/task_model.dart';

class PetService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _petCollection =
      FirebaseFirestore.instance.collection('pets');
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<Map<String, dynamic>> getPetsWithTasks(String userUid) async {
    try {
      QuerySnapshot petSnapshot =
          await _petCollection.where('user_uid', isEqualTo: userUid).get();

      List<Map<String, dynamic>> petsList = [];

      for (var petDoc in petSnapshot.docs) {
        Pet pet = Pet.fromMap(petDoc.data() as Map<String, dynamic>);

        String animalCategoryName =
            pet.animalCategory.isEmpty ? 'Unknown' : pet.animalCategory;

        QuerySnapshot taskSnapshot =
            await _taskCollection.where('pet_uid', isEqualTo: pet.id).get();

        List<Task> tasks = taskSnapshot.docs.map((taskDoc) {
          var taskData = taskDoc.data() as Map<String, dynamic>;
          taskData['id'] = taskDoc.id;

          return Task.fromMap(taskData);
        }).toList();

        var petData = {
          'name': pet.name,
          'animal_category': animalCategoryName,
          'tasks': tasks
              .map((task) => {
                    'id': task.id,
                    'title': task.title,
                    'due_date': task.dueDate.toIso8601String(),
                    'isCompleted': task.isCompleted
                  })
              .toList(),
        };

        petsList.add(petData);
      }

      // print('PetsList length after processing: ${petsList.length}');
      // if (petsList.isNotEmpty) {
      //   print('Complete Pet List: $petsList');
      // } else {
      //   print('PetsList is empty.');
      // }

      return {
        'user_uid': userUid,
        'pets': petsList,
      };
    } catch (e) {
      print('Error fetching pets with tasks: $e');
      return {'user_uid': userUid, 'pets': []};
    }
  }

  Future<List<Pet>> getAllPetsByUserUid() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("User is not logged in.");
      }

      QuerySnapshot petSnapshot = await _petCollection
          .where('user_uid', isEqualTo: currentUser.uid)
          .get();

      return petSnapshot.docs.map((doc) {
        var petData = doc.data() as Map<String, dynamic>;
        petData['id'] = doc.id;
        return Pet.fromMap(petData);
      }).toList();
    } catch (e) {
      print('Error fetching pets for current user: $e');
      return [];
    }
  }

  Future<Pet?> getPetById(String petId) async {
    try {
      DocumentSnapshot petDoc = await _petCollection.doc(petId).get();

      if (petDoc.exists) {
        var petData = petDoc.data() as Map<String, dynamic>;
        petData['id'] = petDoc.id;
        return Pet.fromMap(petData);
      } else {
        print('Pet not found with ID: $petId');
        return null;
      }
    } catch (e) {
      print('Error fetching pet with ID $petId: $e');
      return null;
    }
  }

  Future<void> addPet({
    required String id,
    required String userUid,
    required String name,
    required String animalCategory,
    required DateTime birthDate,
    required String breed,
    required String gender,
    required String imageProfile,
  }) async {
    await _petCollection.doc(id).set({
      'id': id,
      'user_uid': userUid,
      'name': name,
      'animal_category': animalCategory,
      'birth_date': Timestamp.fromDate(birthDate),
      'breed': breed,
      'gender': gender,
      'image_profile': imageProfile,
    });
  }

  Future<void> updatePet({
    required String id,
    String? name,
    String? animalCategory,
    String? breed,
    String? gender,
    String? imageProfile,
    DateTime? birthDate,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (name != null) data['name'] = name;
      if (animalCategory != null) data['animal_category'] = animalCategory;
      if (breed != null) data['breed'] = breed;
      if (gender != null) data['gender'] = gender;
      if (imageProfile != null) data['image_profile'] = imageProfile;
      if (birthDate != null) data['birth_date'] = Timestamp.fromDate(birthDate);

      await _petCollection.doc(id).update(data);

      print('Pet updated successfully');
    } catch (e) {
      print('Error updating pet: $e');
      rethrow;
    }
  }

  Future<void> deletePet(String id) async {
    await _petCollection.doc(id).delete();
  }

  Future<DocumentSnapshot> getPet(String id) async {
    return await _petCollection.doc(id).get();
  }

  Future<QuerySnapshot> getAllPets() async {
    return await _petCollection.get();
  }
}

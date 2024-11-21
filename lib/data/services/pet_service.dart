import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';
import '../models/task_model.dart';

class PetService {
  final CollectionReference _petCollection =
      FirebaseFirestore.instance.collection('pets');
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<Map<String, dynamic>> getPetsWithTasks(String userUid) async {
    try {
      // print('getPetsWithTasks called with userUid: $userUid');

      QuerySnapshot petSnapshot =
          await _petCollection.where('user_uid', isEqualTo: userUid).get();

      // if (petSnapshot.docs.isEmpty) {
      //   print('No pets found for userUid: $userUid');
      // } else {
      //   print('Pets found: ${petSnapshot.docs.length}');
      // }

      List<Map<String, dynamic>> petsList = [];

      for (var petDoc in petSnapshot.docs) {
        // print('Pet Document Data: ${petDoc.data()}');

        Pet pet = Pet.fromMap(petDoc.data() as Map<String, dynamic>);
        // print('Processing Pet: ${pet.name} (ID: ${pet.id})');

        String animalCategoryName =
            pet.animalCategory.isEmpty ? 'Unknown' : pet.animalCategory;

        QuerySnapshot taskSnapshot =
            await _taskCollection.where('pet_uid', isEqualTo: pet.id).get();

        // if (taskSnapshot.docs.isEmpty) {
        //   print('No tasks found for pet ID: ${pet.id}');
        // } else {
        //   print(
        //       'Tasks found for pet ID: ${pet.id} (${taskSnapshot.docs.length} tasks)');
        // }

        List<Task> tasks = taskSnapshot.docs.map((taskDoc) {
          var taskData = taskDoc.data() as Map<String, dynamic>;
          taskData['id'] = taskDoc.id;
          // print('Task Data for pet ${pet.name}: $taskData');

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
    String? breed,
    String? gender,
    String? imageProfile,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (breed != null) data['breed'] = breed;
    if (gender != null) data['gender'] = gender;
    if (imageProfile != null) data['image_profile'] = imageProfile;

    await _petCollection.doc(id).update(data);
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

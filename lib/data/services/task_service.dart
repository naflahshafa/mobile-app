import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');
  final CollectionReference _petCollection =
      FirebaseFirestore.instance.collection('pets');

  Future<List<Task>> getTasksByPetUid(String petUid) async {
    try {
      final taskSnapshot =
          await _taskCollection.where('pet_uid', isEqualTo: petUid).get();

      return taskSnapshot.docs.map((taskDoc) {
        var taskData = taskDoc.data() as Map<String, dynamic>;
        taskData['id'] = taskDoc.id;
        return Task.fromMap(taskData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks for pet: $e');
    }
  }

  Future<Map<String, dynamic>> getTaskAndPetNamesByIdAndPetUid(
      String id, String petUid) async {
    try {
      // Fetch task by id and petUid
      QuerySnapshot taskSnapshot = await _taskCollection
          .where('id', isEqualTo: id)
          .where('pet_uid', isEqualTo: petUid)
          .limit(1)
          .get();

      if (taskSnapshot.docs.isEmpty) {
        throw Exception("No task found with id: $id and pet_uid: $petUid");
      }

      final taskDoc = taskSnapshot.docs.first;
      final task = Task.fromMap({
        ...taskDoc.data() as Map<String, dynamic>,
        'id': taskDoc.id,
      });

      DocumentSnapshot petSnapshot = await _petCollection.doc(petUid).get();

      if (!petSnapshot.exists) {
        throw Exception("Pet not found with UID: $petUid");
      }

      final petData = petSnapshot.data() as Map<String, dynamic>;

      return {
        'task': task.toMap(),
        'pet_name': petData['name'],
      };
    } catch (e) {
      print('Error fetching task and pet name: $e');
      throw Exception('Failed to fetch task and pet data');
    }
  }

  Future<void> addTask({
    required String petUid,
    required String title,
    required String description,
    required DateTime dueDate,
    required bool isCompleted,
  }) async {
    final docRef = _taskCollection.doc();

    await docRef.set({
      'id': docRef.id,
      'pet_uid': petUid,
      'title': title,
      'description': description,
      'due_date': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
    });
  }

  Future<void> updateTask({
    required String id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) async {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (dueDate != null) data['due_date'] = Timestamp.fromDate(dueDate);
    if (isCompleted != null) data['isCompleted'] = isCompleted;

    await _taskCollection.doc(id).update(data);
  }

  Future<void> deleteTask(String id) async {
    await _taskCollection.doc(id).delete();
  }

  Future<DocumentSnapshot> getTask(String id) async {
    return await _taskCollection.doc(id).get();
  }

  Future<QuerySnapshot> getAllTasks() async {
    return await _taskCollection.get();
  }
}

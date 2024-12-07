import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<List<Task>> getTasksByPetUid(String petUid) async {
    try {
      final taskSnapshot =
          await _taskCollection.where('pet_uid', isEqualTo: petUid).get();

      return taskSnapshot.docs.map((taskDoc) {
        var taskData = taskDoc.data() as Map<String, dynamic>;
        taskData['id'] = taskDoc.id; // Add ID manually
        return Task.fromMap(taskData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks for pet: $e');
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
    bool? isCompleted,
  }) async {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
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

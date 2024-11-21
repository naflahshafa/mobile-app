import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask({
    required String id,
    required String petUid,
    required String title,
    required String description,
    required DateTime dueDate,
    required bool isCompleted,
  }) async {
    await _collection.doc(id).set({
      'id': id,
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

    await _collection.doc(id).update(data);
  }

  Future<void> deleteTask(String id) async {
    await _collection.doc(id).delete();
  }

  Future<DocumentSnapshot> getTask(String id) async {
    return await _collection.doc(id).get();
  }

  Future<QuerySnapshot> getAllTasks() async {
    return await _collection.get();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String petUid;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.petUid,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      petUid: data['pet_uid'],
      title: data['title'],
      description: data['description'],
      dueDate: (data['due_date'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_uid': petUid,
      'title': title,
      'description': description,
      'due_date': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
    };
  }
}

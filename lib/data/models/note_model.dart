import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String? id;
  final String petUid;
  final String noteCategory;
  final String title;
  final String description;
  final DateTime? createdAt;

  Note({
    this.id,
    required this.petUid,
    required this.noteCategory,
    required this.title,
    required this.description,
    this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> data, String documentId) {
    return Note(
      id: documentId,
      petUid: data['pet_uid'],
      noteCategory: data['note_category'],
      title: data['title'],
      description: data['description'],
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_uid': petUid,
      'note_category': noteCategory,
      'title': title,
      'description': description,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  static List<String> getNoteCategories() {
    return [
      'appointment',
      'bath',
      'behaviour',
      'diary',
      'exercise',
      'feces',
      'flea',
      'food',
      'grooming',
      'hairball',
      'height',
      'medication',
      'nails',
      'scar',
      'seizure',
      'sleep',
      'surgery',
      'temperature',
      'tick',
      'treatment',
      'urine',
      'vaccine',
      'vocal',
      'vomit',
      'walk',
      'water',
      'weight',
      'other',
    ];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class NoteService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('notes');

  Future<void> addNote({
    required String id,
    required String petUid,
    required String noteCategory,
    required String title,
    required String description,
  }) async {
    await _collection.doc(id).set({
      'id': id,
      'pet_uid': petUid,
      'note_category': noteCategory,
      'title': title,
      'description': description,
    });
  }

  Future<void> updateNote({
    required String id,
    String? noteCategory,
    String? title,
    String? description,
  }) async {
    final Map<String, dynamic> data = {};
    if (noteCategory != null) data['note_category'] = description;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;

    await _collection.doc(id).update(data);
  }

  Future<void> deleteNote(String id) async {
    await _collection.doc(id).delete();
  }

  Future<DocumentSnapshot> getNote(String id) async {
    return await _collection.doc(id).get();
  }

  Future<QuerySnapshot> getAllNotes() async {
    return await _collection.get();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';
import '../models/pet_model.dart';

class NoteService {
  final CollectionReference _noteCollection =
      FirebaseFirestore.instance.collection('notes');
  final CollectionReference _petCollection =
      FirebaseFirestore.instance.collection('pets');

  Future<List<Note>> getNotesByPetUid(String petUid) async {
    try {
      final noteSnapshot =
          await _noteCollection.where('pet_uid', isEqualTo: petUid).get();

      // print('Fetched notes for pet $petUid: ${noteSnapshot.docs.length}');

      if (noteSnapshot.docs.isEmpty) {
        return [];
      }

      return noteSnapshot.docs
          .map(
              (doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notes for pet: $e');
    }
  }

  Future<Map<String, dynamic>> getNoteAndPetNameByIdAndPetUid(
      String id, String petUid) async {
    try {
      QuerySnapshot noteSnapshot = await _noteCollection
          .where('id', isEqualTo: id)
          .where('pet_uid', isEqualTo: petUid)
          .limit(1)
          .get();

      if (noteSnapshot.docs.isEmpty) {
        throw Exception("No note found with id: $id and pet_uid: $petUid");
      }

      final noteDoc = noteSnapshot.docs.first;
      final note =
          Note.fromMap(noteDoc.data() as Map<String, dynamic>, noteDoc.id);

      DocumentSnapshot petSnapshot = await _petCollection.doc(petUid).get();

      if (!petSnapshot.exists) {
        throw Exception("Pet not found with UID: $petUid");
      }

      final pet = Pet.fromMap(petSnapshot.data() as Map<String, dynamic>);

      // print('Fetched Note: ${note.toMap()}');
      // print('Fetched Pet Name: ${pet.name}');

      return {
        'note': note.toMap(),
        'pet_name': pet.name,
      };
    } catch (e) {
      print('Error fetching note and pet name: $e');
      throw Exception('Failed to fetch note and pet data');
    }
  }

  Future<void> addNote({
    required String petUid,
    required String noteCategory,
    required String title,
    required String description,
  }) async {
    try {
      // Menambahkan catatan dengan auto-generated ID
      var noteRef = await _noteCollection.add({
        'pet_uid': petUid,
        'note_category': noteCategory,
        'title': title,
        'description': description,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Menambahkan field 'id' dengan ID yang dihasilkan oleh Firestore
      await noteRef.update({
        'id': noteRef.id,
      });

      // print('Note added with auto-generated ID: ${noteRef.id}');
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  Future<void> updateNote({
    required String id,
    String? noteCategory,
    String? title,
    String? description,
  }) async {
    final Map<String, dynamic> data = {};
    if (noteCategory != null) data['note_category'] = noteCategory;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;

    await _noteCollection.doc(id).update(data);
  }

  Future<void> deleteNote(String id) async {
    await _noteCollection.doc(id).delete();
  }

  Future<DocumentSnapshot> getNote(String id) async {
    return await _noteCollection.doc(id).get();
  }

  Future<QuerySnapshot> getAllNotes() async {
    return await _noteCollection.get();
  }
}

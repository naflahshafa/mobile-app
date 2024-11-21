import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vaccine_model.dart';

class VaccineService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addVaccine({
    required String id,
    required String petUid,
    required String vaccineName,
    required DateTime vaccineDate,
    required String description,
  }) async {
    Vaccine vaccine = Vaccine(
      id: id,
      petUid: petUid,
      vaccineName: vaccineName,
      vaccineDate: vaccineDate,
      description: description,
    );

    try {
      await _db.collection('vaccines').doc(id).set(vaccine.toMap());
      print('Vaccine added successfully');
    } catch (e) {
      print('Failed to add vaccine: $e');
    }
  }

  Future<List<Vaccine>> getVaccinesByPetUid(String petUid) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('vaccines')
          .where('pet_uid', isEqualTo: petUid)
          .get();

      return snapshot.docs.map((doc) {
        return Vaccine.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Failed to fetch vaccines: $e');
      return [];
    }
  }

  Future<void> updateVaccine(Vaccine vaccine) async {
    try {
      await _db.collection('vaccines').doc(vaccine.id).update(vaccine.toMap());
      print('Vaccine updated successfully');
    } catch (e) {
      print('Failed to update vaccine: $e');
    }
  }

  Future<void> deleteVaccine(String vaccineId) async {
    try {
      await _db.collection('vaccines').doc(vaccineId).delete();
      print('Vaccine deleted successfully');
    } catch (e) {
      print('Failed to delete vaccine: $e');
    }
  }
}

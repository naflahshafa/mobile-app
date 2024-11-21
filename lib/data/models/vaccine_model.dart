class Vaccine {
  final String id;
  final String petUid;
  final String vaccineName;
  final DateTime vaccineDate;
  final String description;

  Vaccine({
    required this.id,
    required this.petUid,
    required this.vaccineName,
    required this.vaccineDate,
    required this.description,
  });

  factory Vaccine.fromMap(Map<String, dynamic> data) {
    return Vaccine(
      id: data['id'],
      petUid: data['pet_uid'],
      vaccineName: data['vaccine_name'],
      vaccineDate: data['vaccine_date'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_uid': petUid,
      'vaccine_name': vaccineName,
      'vaccine_date': vaccineDate,
      'description': description,
    };
  }
}

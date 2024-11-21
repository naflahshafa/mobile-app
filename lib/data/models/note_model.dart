class Note {
  final String id;
  final String petUid;
  final String noteCategory;
  final String title;
  final String description;

  Note({
    required this.id,
    required this.petUid,
    required this.noteCategory,
    required this.title,
    required this.description,
  });

  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      id: data['id'],
      petUid: data['pet_uid'],
      noteCategory: data['note_category'],
      title: data['title'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_uid': petUid,
      'note_category': noteCategory,
      'title': title,
      'description': description,
    };
  }
}

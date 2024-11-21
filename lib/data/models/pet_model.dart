import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  final String id;
  final String name;
  final String userUid;
  final String animalCategory;
  final DateTime birthDate;
  final String breed;
  final String gender;
  final String imageProfile;

  Pet({
    required this.id,
    required this.name,
    required this.userUid,
    required this.animalCategory,
    required this.birthDate,
    required this.breed,
    required this.gender,
    required this.imageProfile,
  });

  static List<String> getAnimalCategories() {
    return [
      'alpaca',
      'bird',
      'cat',
      'chicken',
      'chinchilla',
      'cow',
      'crab',
      'dog',
      'donkey',
      'duck',
      'ferret',
      'fish',
      'frog',
      'goat',
      'hamster',
      'horse',
      'insect',
      'llama',
      'lizard',
      'mouse',
      'pig',
      'rabbit',
      'rat',
      'reptile',
      'scorpion',
      'sheep',
      'snake',
      'snail',
      'spider',
      'turtle',
      'other'
    ];
  }

  factory Pet.fromMap(Map<String, dynamic> data) {
    return Pet(
      id: data['id'],
      name: data['name'],
      userUid: data['user_uid'],
      animalCategory: data['animal_category'],
      birthDate: (data['birth_date'] as Timestamp).toDate(),
      breed: data['breed'],
      gender: data['gender'],
      imageProfile: data['image_profile'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user_uid': userUid,
      'animal_category': animalCategory,
      'birth_date': Timestamp.fromDate(birthDate),
      'breed': breed,
      'gender': gender,
      'image_profile': imageProfile,
    };
  }
}

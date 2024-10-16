const String userName = "User";

final List<Pet> pets = [
  Pet(
    name: "Mochi",
    type: "Dog",
    birthDate: DateTime(2022, 5, 12),
    sex: "Male",
    breed: "Golden Retriever",
    tasks: [
      Task(
        title: "Walk",
        time: "01-10-2024 08:00 AM",
        status: true,
      ),
      Task(
        title: "Feed",
        time: "01-10-2024 09:00 AM",
        status: false,
      ),
    ],
    imageUrl: null,
  ),
  Pet(
    name: "Milo",
    type: "Cat",
    birthDate: DateTime(2021, 3, 25),
    sex: "Female",
    breed: "Persian",
    tasks: [
      Task(
        title: "Play",
        time: "01-10-2024 04:00 PM",
        status: false,
      ),
      Task(
        title: "Vet Appointment",
        time: "01-10-2024 10:00 AM",
        status: false,
      ),
    ],
    imageUrl:
        "https://ik.imagekit.io/ggslopv3t/red-white-cat-i-white-studio-cut.jpg?updatedAt=1728912159893",
  ),
  Pet(
    name: "Miko",
    type: "Rabbit",
    birthDate: DateTime(2023, 7, 18),
    sex: "Male",
    breed: "Holland Lop",
    tasks: [],
    imageUrl: null,
  ),
];

class Task {
  final String title;
  final String time;
  final bool status;

  Task({required this.title, required this.time, required this.status});
}

class Pet {
  final String name;
  final String type;
  final DateTime birthDate;
  final String sex;
  final String breed;
  final List<Task> tasks;
  final String? imageUrl;

  Pet({
    required this.name,
    required this.type,
    required this.birthDate,
    required this.sex,
    required this.breed,
    required this.tasks,
    this.imageUrl,
  });
}

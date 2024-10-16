const String userName = "Naflah Shafa";

class Pet {
  final String name;
  final String type;
  final DateTime birthDate;
  final String sex;
  final String breed;
  final List<Task> tasks;
  final List<Note> notes;
  final String? imageUrl;

  Pet({
    required this.name,
    required this.type,
    required this.birthDate,
    required this.sex,
    required this.breed,
    required this.tasks,
    required this.notes,
    this.imageUrl,
  });
}

class Task {
  final String title;
  final String time;
  final bool status;

  Task({required this.title, required this.time, required this.status});
}

class Note {
  final String title;
  final String description;

  Note({required this.title, required this.description});
}

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
    notes: [
      Note(
          title: "Grooming",
          description:
              "Mochi requires grooming every month to maintain his healthy coat and overall hygiene. This includes a thorough brushing to remove any loose fur and prevent matting, as well as a bath with pet-friendly shampoo to keep his skin clean and hydrated. Additionally, regular grooming helps us check for any skin irritations or parasites that may not be immediately visible. Keeping his nails trimmed is also important to ensure his comfort while walking and playing. Scheduling a grooming appointment every month will ensure that Mochi looks and feels his best!"),
      Note(
        title: "Vaccination",
        description: "Next vaccination due on 01-12-2024.",
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
    notes: [
      Note(
        title: "Litter Box",
        description: "Keep the litter box clean daily.",
      ),
      Note(
        title: "Flea Treatment",
        description: "Flea treatment required every 3 months.",
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
    notes: [
      Note(
        title: "Diet",
        description: "Miko requires fresh vegetables daily.",
      ),
      Note(
        title: "Playtime",
        description: "Miko enjoys 30 minutes of playtime every day.",
      ),
    ],
    imageUrl: null,
  ),
];

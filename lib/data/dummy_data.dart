const String userName = "Naflah Shafa";

class DummyPet {
  final String name;
  final String type;
  final DateTime birthDate;
  final String sex;
  final String breed;
  final List<DummyTask> tasks;
  final List<DummyNote> notes;
  final String? imageUrl;

  DummyPet({
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

class DummyTask {
  final String title;
  final String time;
  final bool status;
  final String description;

  DummyTask({
    required this.title,
    required this.time,
    required this.status,
    required this.description,
  });
}

class DummyNote {
  final String title;
  final String description;

  DummyNote({required this.title, required this.description});
}

final List<DummyPet> pets = [
  DummyPet(
    name: "Mochi",
    type: "Dog",
    birthDate: DateTime(2022, 5, 12),
    sex: "Male",
    breed: "Golden Retriever",
    tasks: [
      DummyTask(
        title: "Walk",
        time: "2024-10-01 08:00 AM",
        status: true,
        description: "Take Mochi for a morning walk around the park.",
      ),
      DummyTask(
        title: "Feed",
        time: "2024-10-02 09:00 AM",
        status: false,
        description: "Feed Mochi his favorite dog food.",
      ),
    ],
    notes: [
      DummyNote(
          title: "Grooming",
          description:
              "Mochi requires grooming every month to maintain his healthy coat and overall hygiene. This includes a thorough brushing to remove any loose fur and prevent matting, as well as a bath with pet-friendly shampoo to keep his skin clean and hydrated. Additionally, regular grooming helps us check for any skin irritations or parasites that may not be immediately visible. Keeping his nails trimmed is also important to ensure his comfort while walking and playing. Scheduling a grooming appointment every month will ensure that Mochi looks and feels his best!"),
      DummyNote(
        title: "Vaccination",
        description: "Next vaccination due on 01-12-2024.",
      ),
    ],
    imageUrl: null,
  ),
  DummyPet(
    name: "Milo",
    type: "Cat",
    birthDate: DateTime(2021, 3, 25),
    sex: "Female",
    breed: "Persian",
    tasks: [
      DummyTask(
        title: "Play",
        time: "2024-10-05 04:00 PM",
        status: false,
        description: "Spend quality playtime with Milo using her favorite toy.",
      ),
      DummyTask(
        title: "Vet Appointment",
        time: "2024-10-06 10:00 AM",
        status: false,
        description: "Take Milo for her scheduled vet check-up.",
      ),
    ],
    notes: [
      DummyNote(
        title: "Litter Box",
        description: "Keep the litter box clean daily.",
      ),
      DummyNote(
        title: "Flea Treatment",
        description: "Flea treatment required every 3 months.",
      ),
    ],
    imageUrl:
        "https://ik.imagekit.io/ggslopv3t/red-white-cat-i-white-studio-cut.jpg?updatedAt=1728912159893",
  ),
  DummyPet(
    name: "Miko",
    type: "Rabbit",
    birthDate: DateTime(2023, 7, 18),
    sex: "Male",
    breed: "Holland Lop",
    tasks: [
      DummyTask(
        title: "Vet Appointment",
        time: "2024-10-01 10:00 AM",
        status: false,
        description: "Take Miko for his scheduled vet check-up.",
      ),
    ],
    notes: [
      DummyNote(
        title: "Diet",
        description: "Miko requires fresh vegetables daily.",
      ),
      DummyNote(
        title: "Playtime",
        description: "Miko enjoys 30 minutes of playtime every day.",
      ),
    ],
    imageUrl: null,
  ),
];

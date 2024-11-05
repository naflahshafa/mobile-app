import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../components/bottom_navbar.dart';
import '../../components/header.dart';
import '../../data/dummy_data.dart';

class EditPetProfileScreen extends StatefulWidget {
  final Pet pet;

  const EditPetProfileScreen({super.key, required this.pet});

  @override
  _EditPetProfileScreenState createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends State<EditPetProfileScreen> {
  int currentIndex = 1; // Atur indeks awal untuk bottom nav
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String dateOfBirth;
  late String sex;
  late String breed;
  late String category;
  String? imageUrl; // Variabel untuk menyimpan URL gambar yang diunggah

  final ImagePicker _picker = ImagePicker(); // Inisialisasi ImagePicker

  @override
  void initState() {
    super.initState();
    // Inisialisasi variabel dengan data pet yang ada
    name = widget.pet.name;
    dateOfBirth = widget.pet.birthDate.toString(); // Format sesuai kebutuhan
    sex = widget.pet.sex;
    breed = widget.pet.breed;
    category = widget.pet.type;
    imageUrl = widget.pet.imageUrl; // Set imageUrl awal
  }

  Future<void> _uploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Mengambil gambar dari galeri
    );

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path; // Simpan path gambar yang dipilih
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(dateOfBirth),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.parse(dateOfBirth)) {
      setState(() {
        dateOfBirth = picked.toIso8601String(); // Simpan tanggal yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Pet Notes'), // Gunakan CustomHeader
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey, // Mengaitkan Form dengan GlobalKey
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Edit Pet Profile', // Judul ditambahkan di sini
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            height: 20), // Jarak antara judul dan gambar
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: (imageUrl != null &&
                                      imageUrl!.isNotEmpty)
                                  ? FileImage(File(
                                      imageUrl!)) // Gambar yang diunggah jika ada
                                  : (widget.pet.imageUrl != null &&
                                          widget.pet.imageUrl!.isNotEmpty)
                                      ? NetworkImage(widget
                                          .pet.imageUrl!) // Gambar URL jika ada
                                      : const NetworkImage(
                                          'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260', // Gambar default
                                        ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Color(0xFF333333)),
                                  onPressed: () async {
                                    await _uploadImage(); // Panggil fungsi untuk mengunggah gambar
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Name',
                          icon: Icons.edit,
                          onChanged: (value) => name = value,
                          initialValue: name,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: _buildTextField(
                              label: 'Date of Birth',
                              icon: Icons.calendar_today,
                              onChanged: (value) => dateOfBirth = value,
                              initialValue: dateOfBirth.substring(
                                  0, 10), // Format tanggal
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // const Text(
                        //   'Sex',
                        //   style: TextStyle(fontSize: 16),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Male',
                                  groupValue: sex,
                                  onChanged: (value) {
                                    setState(() {
                                      sex = value!;
                                    });
                                  },
                                ),
                                const Text('Male'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Female',
                                  groupValue: sex,
                                  onChanged: (value) {
                                    setState(() {
                                      sex = value!;
                                    });
                                  },
                                ),
                                const Text('Female'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          label: 'Breed',
                          icon: Icons.pets,
                          onChanged: (value) => breed = value,
                          initialValue: breed,
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownField(
                          label: 'Category',
                          icon: Icons.category,
                          items: ['Cat', 'Dog', 'Bird', 'Rabbit', 'Other'],
                          onChanged: (value) => category = value!,
                          initialValue: category,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              label: 'Cancel',
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(
                                    context); // Kembali tanpa perubahan
                              },
                            ),
                            const SizedBox(width: 10),
                            _buildActionButton(
                              label: 'Update',
                              color: Colors.blue,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Jika form valid, pop dengan data yang diubah
                                  Navigator.pop(
                                    context,
                                    Pet(
                                      name: name,
                                      birthDate: DateTime.parse(
                                          dateOfBirth), // Pastikan formatnya benar
                                      sex: sex,
                                      breed: breed,
                                      type: category,
                                      tasks: [],
                                      notes: [],
                                      imageUrl:
                                          imageUrl, // Gambar yang diunggah
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index; // Update the current index
          });
        },
      ), // Custom bottom navbar dengan parameter yang diperlukan
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null; // Return null if input is valid
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    String? initialValue,
  }) {
    return DropdownButtonFormField<String>(
      value: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select $label';
        }
        return null; // Return null if selection is valid
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

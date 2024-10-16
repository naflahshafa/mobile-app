import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../components/bottom_navbar.dart';
import '../components/header.dart';

class AddPetScreen extends StatefulWidget {
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  int currentIndex = 1;
  final _formKey = GlobalKey<FormState>();
  late String name;
  DateTime? dateOfBirth; // Variabel untuk tanggal lahir
  String? sex; // Ubah menjadi nullable
  late String breed;
  late String category;
  String? imageUrl; // Variabel untuk menyimpan URL gambar yang diunggah

  final ImagePicker _picker = ImagePicker();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dateOfBirth = picked; // Simpan tanggal yang dipilih
      });
    }
  }

  Future<void> _uploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path; // Simpan path gambar yang dipilih
      });
    }
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
              ? FileImage(File(imageUrl!))
              : const NetworkImage(
                  'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF333333)),
              onPressed: _uploadImage, // Panggil fungsi untuk mengunggah gambar
            ),
          ),
        ),
      ],
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
        border: OutlineInputBorder(),
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

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            ),
            child: Text(
              date != null
                  ? DateFormat('yyyy-MM-dd').format(date)
                  : 'Select date', // Placeholder jika tidak ada tanggal
              style: TextStyle(
                  fontSize: 16,
                  color: date == null
                      ? Colors.grey
                      : Colors.black), // Warna placeholder abu-abu
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: sex,
                  onChanged: (value) {
                    setState(() {
                      sex = value;
                    });
                  },
                ),
                Text('Male'),
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Female',
                  groupValue: sex,
                  onChanged: (value) {
                    setState(() {
                      sex = value;
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(95.0),
        child: CustomHeader(title: 'Pet Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
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
                        const Text('Add New Pet',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        _buildProfileImage(),
                        const SizedBox(height: 20),
                        _buildTextField(
                            label: 'Name',
                            icon: Icons.edit,
                            onChanged: (value) => name = value),
                        const SizedBox(height: 10),
                        _buildDateField(
                          'Date of Birth',
                          dateOfBirth,
                          () => _selectDate(
                              context), // Fungsi untuk memilih tanggal
                        ), // Gunakan fungsi baru untuk field tanggal
                        const SizedBox(height: 10),
                        _buildGenderField(), // Tambahkan radio button untuk jenis kelamin
                        const SizedBox(height: 10),
                        _buildTextField(
                            label: 'Breed',
                            icon: Icons.pets,
                            onChanged: (value) => breed = value),
                        const SizedBox(height: 10),
                        _buildTextField(
                            label: 'Category',
                            icon: Icons.category,
                            onChanged: (value) => category = value),
                        const SizedBox(height: 20),

                        // Tombol Cancel dan Save
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Logika untuk cancel
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red, // Warna tombol Cancel
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Color(
                                          0xFFFFFFFF)), // Warna tulisan putih
                                ),
                              ),
                            ),
                            const SizedBox(width: 5), // Jarak antara tombol
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Logika untuk menyimpan data pet
                                    // Misalnya: savePet(name, dateOfBirth, sex, breed, category, imageUrl);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.blue, // Warna tombol Save
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Color(
                                          0xFFFFFFFF)), // Warna tulisan putih
                                ),
                              ),
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
            currentIndex = index;
          });
        },
      ),
    );
  }
}

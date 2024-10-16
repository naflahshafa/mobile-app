import 'package:flutter/material.dart';
import '../components/bottom_navbar.dart';
import '../components/header.dart';
import 'edit_profile_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95.0),
        child: const CustomHeader(title: 'Pet Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              children: [
                const Icon(Icons.settings, size: 30, color: Color(0xFF333333)),
                const SizedBox(width: 10),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Center the rest of the content vertically
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align content to the start
                  children: [
                    CircleAvatar(
                      radius: 50, // Adjust the radius for profile picture
                      backgroundImage: NetworkImage(
                          'https://ik.imagekit.io/ggslopv3t/cropped_image.png?updatedAt=1728912899260'),
                    ),
                    const SizedBox(height: 10), // Reduced spacing
                    const Text(
                      'Naflah Shafa',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20), // Space before buttons

                    // Edit Profile Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15), // Button height
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0), // Add horizontal padding
                              child: Row(
                                children: [
                                  const Icon(Icons.edit,
                                      color: Color(
                                          0xFF333333)), // Icon for Edit Profile
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Color(0xFF333333), // Text color
                                      fontSize: 16, // Adjust font size
                                      fontWeight: FontWeight.bold, // Bold font
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 16.0), // Padding for the arrow
                              child: const Icon(
                                Icons.arrow_forward_ios, // Arrow icon
                                size: 16,
                                color:
                                    Color(0xFF333333), // Color for arrow icon
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Add some spacing

                    // Logout Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context,
                            '/welcome'); // Navigate to the /welcome route
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15), // Button height
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0), // Add horizontal padding
                              child: Row(
                                children: [
                                  const Icon(Icons.logout,
                                      color:
                                          Color(0xFF333333)), // Icon for Logout
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Color(0xFF333333), // Text color
                                      fontSize: 16, // Adjust font size
                                      fontWeight: FontWeight.bold, // Bold font
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 16.0), // Padding for the arrow
                              child: const Icon(
                                Icons.arrow_forward_ios, // Arrow icon
                                size: 16,
                                color:
                                    Color(0xFF333333), // Color for arrow icon
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            // Handle navigation based on index
          });
        },
      ),
    );
  }
}

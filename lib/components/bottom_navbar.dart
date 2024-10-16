import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFFFFF),
        currentIndex: currentIndex,
        onTap: (index) {
          onTap(index); // Panggil onTap untuk memperbarui state di HomePage
          _navigateToPage(context, index); // Panggil fungsi untuk navigasi
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: const Color(0xFF333333),
        unselectedItemColor: const Color(0xFFD7D7D7),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-page');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/pets');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/tasks');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      default:
        break;
    }
  }
}

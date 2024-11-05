import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/logo_app.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 150),
            // Welcome Message
            const Text(
              'Welcome to Pet Notes!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: const Text(
                'Pet Notes is designed to help you manage all the information and tasks related to your pet\'s needs and care.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGradientButton(
                  context: context,
                  text: 'Sign up',
                  route: '/register',
                ),
                _buildGradientButton(
                  context: context,
                  text: 'Sign in',
                  route: '/login',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required BuildContext context,
    required String text,
    required String route,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ElevatedButton(
        onPressed: () {
          context.go(route);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 20),
          backgroundColor:
              Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

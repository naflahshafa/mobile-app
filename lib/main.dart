import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/welcome_page.dart';
import 'screens/menu-home/home_screen.dart';
import 'screens/menu-pets/pet_screen.dart';
import 'screens/menu-pets/add_pet_screen.dart';
import 'screens/menu-tasks/task_screen.dart';
import 'screens/menu-settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pet Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    // Route navbar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF4B2FB8),
            currentIndex: _calculateCurrentIndex(state.uri.toString()),
            onTap: (index) => _onNavBarTap(context, index),
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
            selectedItemColor: const Color(0xFFFFC443),
            unselectedItemColor: const Color(0xFFD7D7D7),
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/pets',
          builder: (context, state) => const PetPage(),
          routes: [
            GoRoute(
              path: 'addPet',
              builder: (context, state) => AddPetScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const TaskPage(),
          routes: [
            // Nested routes for tasks
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
          routes: [
            // Nested routes for settings
          ],
        ),
      ],
    ),
  ],
);

int _calculateCurrentIndex(String location) {
  switch (location) {
    case '/home':
      return 0;
    case '/pets':
      return 1;
    case '/pets/addPet':
      return 1;
    case '/tasks':
      return 2;
    case '/settings':
      return 3;
    default:
      return 0;
  }
}

void _onNavBarTap(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go('/home');
      break;
    case 1:
      context.go('/pets');
      break;
    case 2:
      context.go('/tasks');
      break;
    case 3:
      context.go('/settings');
      break;
    default:
      break;
  }
}

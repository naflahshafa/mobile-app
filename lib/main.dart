import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_notes/data/models/pet_model.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/welcome_page.dart';
import 'screens/menu-home/home_screen.dart';
import 'screens/menu-pets/pet_screen.dart';
import 'screens/menu-pets/list-profile-pet/pet_profile_screen.dart';
import 'screens/menu-pets/list-profile-pet/edit_pet_profile_screen.dart';
import 'screens/menu-pets/list-profile-pet/add_pet_screen.dart';
import 'screens/menu-pets/notes/add_pet_note_screen.dart';
import 'screens/menu-pets/notes/pet_note_detail_screen.dart';
import 'screens/menu-pets/notes/edit_pet_note_screen.dart';
import 'screens/menu-tasks/task_screen.dart';
import 'screens/menu-tasks/add_pet_task_screen.dart';
import 'screens/menu-settings/settings_screen.dart';
import 'screens/menu-settings/edit_profile_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
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
    GoRoute(
      path: '/pets/addPet',
      builder: (context, state) => AddPetScreen(),
    ),
    GoRoute(
      path: '/pets/profile/:petId',
      builder: (context, state) {
        final petId = state.pathParameters['petId'];
        return PetProfileScreen(petId: petId!);
      },
      routes: [
        GoRoute(
          path: 'editProfile',
          builder: (context, state) {
            final pet = state.extra as Pet;
            return EditPetProfileScreen(pet: pet);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/pets/addPetNote',
      builder: (context, state) => const AddPetNoteScreen(),
    ),
    GoRoute(
      path: '/pets/noteDetail/:noteId/:petUid',
      builder: (context, state) {
        final noteId = state.pathParameters['noteId']!;
        final petUid = state.pathParameters['petUid']!;
        return NoteDetailPage(noteId: noteId, petUid: petUid);
      },
      routes: [
        GoRoute(
          path: 'editPetNote',
          builder: (context, state) {
            final noteId = state.pathParameters['noteId']!;
            final petUid = state.pathParameters['petUid']!;
            return EditPetNoteScreen(noteId: noteId, petUid: petUid);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/tasks/addPetTask',
      builder: (context, state) => const AddPetTaskScreen(),
    ),

    // Route navbar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF7B3A10),
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
            selectedItemColor: const Color(0xFFD2C4A9),
            unselectedItemColor: const Color(0xFFC28460),
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
          builder: (context, state) {
            final tabIndex = state.extra != null
                ? (state.extra as Map<String, dynamic>)['tabIndex'] ?? 0
                : 0;
            return PetPage(initialTabIndex: tabIndex);
          },
          routes: [
            // if needed
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
            GoRoute(
              path: 'editProfile',
              builder: (context, state) => const EditProfilePage(),
            ),
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
    case '/tasks':
      return 2;
    case '/settings':
      return 3;
    case '/settings/editProfile':
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

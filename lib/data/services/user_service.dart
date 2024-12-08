import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserData() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      } catch (error) {
        print('Error fetching user data: $error');
      }
    }

    return null;
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (error) {
      print('Error saving user data: $error');
    }
  }

  Future<void> updateUserData({String? username, String? email}) async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('No user is currently logged in');
    }

    try {
      final Map<String, dynamic> updates = {};

      if (username != null && username.isNotEmpty) {
        updates['username'] = username;
      }

      if (email != null && email.isNotEmpty) {
        await currentUser.verifyBeforeUpdateEmail(email);
        updates['email'] = email; // Reflect changes in Firestore
      }

      if (updates.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update(updates);
      }
    } catch (error) {
      print('Error updating user data: $error');
      throw Exception('Failed to update user data: $error');
    }
  }
}

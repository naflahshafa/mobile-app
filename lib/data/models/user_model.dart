class UserModel {
  final String uid;
  final String email;
  final String username;
  final String imageProfile;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.imageProfile,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    // print('Raw userdata from Firestore: $data');
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      imageProfile: data['image_profile'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'image_profile': imageProfile,
    };
  }
}

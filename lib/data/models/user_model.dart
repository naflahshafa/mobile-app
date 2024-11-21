class UserModel {
  final String id;
  final String uid;
  final String email;
  final String username;
  final String imageProfile;

  UserModel({
    required this.id,
    required this.uid,
    required this.email,
    required this.username,
    required this.imageProfile,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      imageProfile: data['image_profile'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'email': email,
      'username': username,
      'image_profile': imageProfile,
    };
  }
}

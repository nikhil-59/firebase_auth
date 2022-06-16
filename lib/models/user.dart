class UserModel {
  String uid;
  String email;
  String name;
  String imageUrl;

  UserModel(
      {required this.uid,
      required this.email,
      required this.name,
      required this.imageUrl});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_authentication/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class DBService {
  String? uid;
  DBService({this.uid});
  final _db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  Future storeUsertoDB(String email, String name, String? imageUrl) async {
    imageUrl ??= "http://cdn.onlinewebfonts.com/svg/img_335286.png";
    UserModel user =
        UserModel(uid: uid!, name: name, email: email, imageUrl: imageUrl);
    await _db.collection('users').doc(uid).set(user.toMap());
  }

  UserModel userFromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
        uid: uid!,
        email: snapshot.get('email'),
        name: snapshot.get('name'),
        imageUrl: snapshot.get('imageUrl'));
  }

  Future<String?> uploadFile(File? photo) async {
    if (photo == null) return null;
    final fileName = p.basename(photo.path);
    final destination = 'files/$fileName';

    try {
      final ref = storage.ref(destination).child('file/');
      final uploadTask = await ref.putFile(photo);
      final url = await uploadTask.ref.getDownloadURL();
      return url.toString();
    } catch (e) {
      print('error occured');
      return null;
    }
  }

  Stream<UserModel> get userData {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((value) => userFromSnapshot(value));
  }
}

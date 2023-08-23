import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class user {
  String name;
  String uid;
  String email;
  String profilePhoto;
  user({
    required this.uid,
    required this.email,
    required this.name,
    required this.profilePhoto,
  });
  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "profilePhoto": profilePhoto,
      };
  static user fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return user(
        uid: snapshot['uid'],
        email: snapshot['email'],
        name: snapshot['name'],
        profilePhoto: snapshot['profilePhoto']);
  }
}

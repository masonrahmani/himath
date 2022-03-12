import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_host_group_chat_app/features/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    String name = "username",
    String email = "",
    String uid = "",
    String about = "",
    String location = "",
  }) : super(
          name: name,
          email: email,
          uid: uid,
          about: about,
          location: location,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        email: json['email'],
        uid: json['uid'],
        about: json['about'],
        location: json['location']);
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      name: snapshot.get('name'),
      email: snapshot.get('email'),
      uid: snapshot.get('uid'),
      about: snapshot.get('about'),
      location: snapshot.get('location'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "about": about,
      "location": location,
    };
  }
}

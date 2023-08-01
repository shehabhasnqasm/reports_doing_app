import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required super.uid,
      required super.name,
      required super.email,
      required super.phoneNumber,
      required super.profileUrl,
      required super.positionInCompany,
      required super.createdAt,
      required super.active});

  factory UserModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserModel(
      uid: documentSnapshot.get('uid'),
      name: documentSnapshot.get('name'),
      email: documentSnapshot.get('email'),
      phoneNumber: documentSnapshot.get("phoneNumber"),
      profileUrl: documentSnapshot.get("profileUrl"),
      positionInCompany: documentSnapshot.get("positionInCompany"),
      createdAt: documentSnapshot.get("createdAt"),
      active: documentSnapshot.get('active'),
      // or
      // uid: documentSnapshot['uid'],
      // name: documentSnapshot['name'],
      // email: documentSnapshot['email'],
      // phoneNumber: documentSnapshot["phoneNumber"],
      // profileUrl: documentSnapshot["profileUrl"],
      // positionInCompany: documentSnapshot["positionInCompany"],
      // createdAt: documentSnapshot["createdAt"],
      // active: documentSnapshot['active'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "profileUrl": profileUrl,
      "positionInCompany": positionInCompany,
      "createdAt": createdAt,
      "active": active
    };
  }

  // factory UserModel.fromjson(Map<String, dynamic> json) {
  //   return UserModel(
  //       uid: json['id'],
  //       name: json['name'],
  //       email: json['email'],
  //       password: json['password']);
  // }

  // Map<String, dynamic> tojson() {
  //   return {'id': uid, 'name': name, 'email': email, 'password': password};
  // }
}

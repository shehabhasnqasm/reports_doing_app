import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String profileUrl;
  final String positionInCompany;
  final Timestamp createdAt;
  final bool active;
  const UserEntity(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.profileUrl,
      required this.positionInCompany,
      required this.createdAt,
      required this.active});

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        phoneNumber,
        profileUrl,
        positionInCompany,
        createdAt,
        active
      ];
}


// class UserEntity extends Equatable {
//   final String? name;
//   final String? email;
//   final String? uid;
//   final String? status;
//   final String? password;

//   UserEntity({
//     this.name,
//     this.email,
//     this.uid,
//     this.status = "Hello there i'm using this app",
//     this.password,
//   });

//   @override
//   // TODO: implement props
//   List<Object?> get props => [
//         name,
//         email,
//         uid,
//         status,
//         password,
//       ];
// }
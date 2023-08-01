import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/email_user_entity.dart';

class EmailUserModel extends EmailUserEntity {
  EmailUserModel({
    required super.email,
    required super.name,
  });

  factory EmailUserModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return EmailUserModel(
      email: documentSnapshot.get('email'),
      name: documentSnapshot.get('name'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "email": email,
      "name": name,
    };
  }
}

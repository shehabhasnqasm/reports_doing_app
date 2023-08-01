import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String? name;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? profileUrl;
  final String? positionInCompany;
  const UserData(
      {this.name,
      required this.email,
      required this.password,
      this.phoneNumber,
      this.profileUrl,
      this.positionInCompany});

  @override
  List<Object?> get props =>
      [name, email, password, phoneNumber, profileUrl, positionInCompany];
}

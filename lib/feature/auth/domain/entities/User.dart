import 'package:chat/feature/auth/data/model/user.dart';

enum Gender { male, female }

class User {
  String? sid;
  String? name;
  String? email;
  String? password;
  bool? emailIsValidate;
  Gender? gender;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? block;
  List<UserModel>? subscribers;

  User({
    this.sid,
    this.name,
    this.email,
    this.password,
    this.emailIsValidate,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.subscribers,
    this.block,
  });
}

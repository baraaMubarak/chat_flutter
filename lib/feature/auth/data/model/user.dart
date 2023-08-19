import 'package:chat/feature/auth/domain/entities/User.dart';

class UserModel extends User {
  UserModel(User user) {
    sid = user.sid;
    name = user.name;
    email = user.email;
    emailIsValidate = user.emailIsValidate;
    gender = user.gender;
    dateOfBirth = user.dateOfBirth;
    createdAt = user.createdAt;
    updatedAt = user.updatedAt;
    iV = user.iV;
    password = user.password;
    subscribers = user.subscribers;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    sid = json['_id'];
    name = json['name'];
    email = json['email'];
    emailIsValidate = json['emailIsValidate'];
    gender = json['gender'] == 'male' ? Gender.male : Gender.female;
    dateOfBirth = json['dateOfBirth'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    password = json['password'];
    if (json['subscribers'] != null) {
      subscribers = (json['subscribers'] as List)
          .map((e) => UserModel(User(
                sid: e['_id'],
                name: e['name'],
                email: e['email'],
              )))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = super.name;
    data['email'] = super.email;
    data['emailIsValidate'] = super.emailIsValidate;
    if (super.gender != null) data['gender'] = super.gender!.name;
    data['dateOfBirth'] = super.dateOfBirth;
    data['_id'] = super.sid;
    data['createdAt'] = super.createdAt;
    data['updatedAt'] = super.updatedAt;
    data['__v'] = super.iV;
    data['password'] = super.password;
    if (super.subscribers != null) {
      data['subscribers'] = super.subscribers!.map((e) {
        return e.toJson();
      }).toList();
    }
    return data;
  }
}

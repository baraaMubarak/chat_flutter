import 'package:chat/feature/auth/domain/entities/User.dart';

class UserModel extends User {
  UserModel(User user) {
    name = user.name;
    email = user.email;
    emailIsValidate = user.emailIsValidate;
    gender = user.gender;
    dateOfBirth = user.dateOfBirth;
    sId = user.sId;
    createdAt = user.createdAt;
    updatedAt = user.updatedAt;
    iV = user.iV;
    password = user.password;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    emailIsValidate = json['emailIsValidate'];
    gender = json['gender'] == 'male' ? Gender.male : Gender.female;
    dateOfBirth = json['dateOfBirth'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = super.name;
    data['email'] = super.email;
    data['emailIsValidate'] = super.emailIsValidate;
    data['gender'] = super.gender!.name;
    data['dateOfBirth'] = super.dateOfBirth;
    data['_id'] = super.sId;
    data['createdAt'] = super.createdAt;
    data['updatedAt'] = super.updatedAt;
    data['__v'] = super.iV;
    data['password'] = super.password;
    return data;
  }
}

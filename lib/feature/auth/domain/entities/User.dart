enum Gender { male, female }

class User {
  String? name;
  String? email;
  String? password;
  bool? emailIsValidate;
  Gender? gender;
  String? dateOfBirth;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User({
    this.name,
    this.email,
    this.password,
    this.emailIsValidate,
    this.gender,
    this.dateOfBirth,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });
}

class UserModel {
  String? imagePath;
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  int registrationDate;

  UserModel(
      {this.imagePath,
      this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.registrationDate = 0});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        registrationDate: map['registrationDate'],
        imagePath: map['imagePath']);
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'registrationDate': registrationDate,
      'imagePath': imagePath
    };
  }
}

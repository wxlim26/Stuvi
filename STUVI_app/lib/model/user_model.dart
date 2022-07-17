class UserModel {
  String? imageBase64;
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  int registrationDate;
  String title;

  UserModel(
      {this.imageBase64,
      this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.registrationDate = 0,
      this.title = ''});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        registrationDate: map['registrationDate'],
        imageBase64: map['imagePath'],
        title: map['title']);
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'registrationDate': registrationDate,
      'imagePath': imageBase64,
      'title': title
    };
  }
}

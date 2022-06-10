class UserStatsModel {
  String? uid;
  num? exp;

  UserStatsModel({this.uid, this.exp});

  // receiving data from server
  factory UserStatsModel.fromMap(map) {
    return UserStatsModel(
      uid: map['uid'],
      exp: map['exp'],
    );
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'exp': exp,
    };
  }
}

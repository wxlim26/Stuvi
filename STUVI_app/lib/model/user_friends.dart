class UserFriends {
  String? uid;
  bool privacyMode;
  List friendList;

  UserFriends({this.uid, this.privacyMode = false, this.friendList = const []});

  // receiving data from server
  factory UserFriends.fromMap(map) {
    return UserFriends(
      uid: map['uid'],
      privacyMode: map['privacyMode'],
      friendList: map['friendList'],
    );
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'privacyMode': privacyMode,
      'friendList': friendList,
    };
  }
}

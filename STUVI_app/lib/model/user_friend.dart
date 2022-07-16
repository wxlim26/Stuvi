class UserFriend {
  String? uid;
  String status;
  int requestedAt;
  String requestedID;

//Pending, Friends, Blocked,
  UserFriend(
      {this.uid,
      this.status = 'PENDING',
      this.requestedAt = 0,
      this.requestedID = ''});

  // receiving data from server
  factory UserFriend.fromMap(map) {
    return UserFriend(
        uid: map['uid'],
        status: map['status'],
        requestedAt: map['requestedAt'],
        requestedID: map['requestedID']);
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'status': status,
      'requestedAt': requestedAt,
      'requestedID': requestedID
    };
  }
}

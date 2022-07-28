import 'package:STUVI_app/model/user_friend.dart';

class UserFriends {
  String? uid;
  bool privacyMode;
  List<UserFriend> friendList;
  bool? unlockFriendAchievement;

  UserFriends({
    this.uid,
    this.privacyMode = false,
    this.friendList = const [],
    this.unlockFriendAchievement,
  });

  // receiving data from server
  factory UserFriends.fromMap(map) {
    return UserFriends(
        uid: map['uid'],
        privacyMode: map['privacyMode'],
        friendList: ((map['friendList'] as List)
            .map((v) => UserFriend.fromMap(v))
            .toList()),
        unlockFriendAchievement: map['unlockFriendAchievement']);
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'privacyMode': privacyMode,
      'friendList': friendList.map((e) => e.toMap()).toList(),
      'unlockFriendAchievement': unlockFriendAchievement,
    };
  }
}

import 'package:STUVI_app/Achievements/achievement.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/widget/achievements_progress_view_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class FriendTileDisplay extends StatefulWidget {
  final String uid;
  final bool priv;
  FriendTileDisplay({
    Key? key,
    required this.uid,
    required this.priv,
  }) : super(key: key);

  @override
  State<FriendTileDisplay> createState() => _FriendsDisplayState();
}

class _FriendsDisplayState extends State<FriendTileDisplay> {
  UserModel friendProfile = UserModel();
  UserStatsModel friendStat = UserStatsModel();
  UserFriends userFriend = UserFriends();
  bool isLoading = false;
  String initials = '';
  String fullName = '';

  UserStatsModel getFriendStats(String uid) {
    FirebaseFirestore.instance
        .collection("UserStats")
        .doc(uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (mounted) {
        setState(() {
          friendStat = UserStatsModel.fromMap(doc.data());
        });
      }
    });
    return friendStat;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get()
        .then(((value) {
      if (mounted) {
        setState(() {
          friendProfile = UserModel.fromMap(value.data());
          initials = (friendProfile.firstName![0] + friendProfile.lastName![0])
              .toUpperCase();
          fullName = friendProfile.firstName! + ' ' + friendProfile.lastName!;
        });
      }
    }));

    final friendStat = getFriendStats(widget.uid);

    if (friendProfile == null) {
      isLoading = true;
    }
    return isLoading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              child: Text(
                '${initials}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              '${fullName}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onTap: () {
              num level = (friendStat.exp! / 500).floor();
              showDialog(
                context: context,
                builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new SimpleDialog(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${fullName}'),
                          ]),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      children: [
                        Center(
                          child: Text('Level : ${level}'),
                        ),
                        SizedBox(height: 15),
                        widget.priv
                            ? Container(
                                height: 300,
                                child: Center(
                                    child: Text('Private',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))))
                            : Container(
                                height: 300,
                                child: AchievementsProgressView(
                                  achievements: Achievement.getList(
                                      //level!
                                      level,
                                      Achievement.levelAchievements()),
                                ),
                              )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }
}

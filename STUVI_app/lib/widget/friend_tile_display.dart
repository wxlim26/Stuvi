import 'dart:convert';

import 'package:STUVI_app/API/firebase_api.dart';
import 'package:STUVI_app/Achievements/achievement.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/widget/achievements_progress_view_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';

class FriendTileDisplay extends StatefulWidget {
  final String loggedinpersonID;
  final String uid;
  final bool priv;
  String status;
  final Function onSuccessfullyRequest;
  final Function onRejectedRequest;
  final String requestedPersonID;

  FriendTileDisplay({
    Key? key,
    required this.uid,
    required this.priv,
    required this.status,
    required this.onSuccessfullyRequest,
    required this.onRejectedRequest,
    required this.requestedPersonID,
    required this.loggedinpersonID,
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

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  UserStatsModel stats = UserStatsModel();
  num? level;
  num? xp;
  var image;
  int totalTask = 0;
  int totalFriends = 0;
  bool friendAchievementUnlocked = false;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("UserStats")
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot doc) {
      this.stats = UserStatsModel.fromMap(doc.data());
      setState(() {
        level = (stats.exp! / 500).floor();
        xp = stats.exp!;
      });
    });

    FirebaseApi.getAllTodos(widget.uid).then((QuerySnapshot value) {
      setState(() {
        totalTask = value.docs.length;
      });
    });

    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (mounted) {
        UserFriends userFriends = UserFriends.fromMap(doc.data());
        setState(() {
          friendAchievementUnlocked = userFriends.unlockFriendAchievement!;
        });
      }
    });
  }

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

    Widget renderLabel(String text) {
      return Container(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Oxygen',
            fontSize: 12,
          ),
        ),
      );
    }

    final Widget line = Container(
        height: 0.5,
        margin: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        color: Colors.black);

    final friendStat = getFriendStats(widget.uid);

    String firstName =
        friendProfile.firstName != null ? friendProfile.firstName! : "";

    String lastName =
        friendProfile.lastName != null ? friendProfile.lastName![0] : "";

    final changeRequestStatus = Column(children: <Widget>[
      Text(
        'Friend request from' + '\n' + '${firstName + "" + lastName}',
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => {
              widget.status = 'ACCEPTED',
              widget.onSuccessfullyRequest(),
              Navigator.pop(context),
            },
            child: Text(
              'ACCEPT',
              style: TextStyle(
                  fontFamily: 'OxygenBold',
                  color: Color(0xFF31AFE1),
                  fontSize: 15),
            ),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () => {
              widget.onRejectedRequest(),
              Navigator.pop(context),
            },
            child: Text(
              'DECLINE',
              style: TextStyle(
                  color: Colors.red, fontFamily: 'OxygenBold', fontSize: 15),
            ),
          ),
        ],
      ),
    ]);

    final cancelRequestStatus = Column(children: <Widget>[
      Text(
        'Cancel friend request to' + '\n' + '${firstName + "" + lastName}',
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => {
              widget.onRejectedRequest(),
              Navigator.pop(context),
            },
            child: Text(
              'CANCEL',
              style: TextStyle(
                  fontFamily: 'OxygenBold',
                  color: Color(0xFF31AFE1),
                  fontSize: 15),
            ),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () => {
              Navigator.pop(context),
            },
            child: Text(
              'EXIT',
              style: TextStyle(
                  color: Colors.red, fontFamily: 'OxygenBold', fontSize: 15),
            ),
          ),
        ],
      ),
    ]);

    final unblockRequestStatus = Column(children: <Widget>[
      Text(
        'Unblock ' + '${firstName + "" + lastName}',
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => {
              widget.onRejectedRequest(),
              Navigator.pop(context),
            },
            child: Text(
              'UNBLOCK',
              style: TextStyle(
                  fontFamily: 'OxygenBold',
                  color: Color(0xFF31AFE1),
                  fontSize: 15),
            ),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () => {
              Navigator.pop(context),
            },
            child: Text(
              'EXIT',
              style: TextStyle(
                  color: Colors.red, fontFamily: 'OxygenBold', fontSize: 15),
            ),
          ),
        ],
      ),
    ]);

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
              if (widget.status == 'ACCEPTED') {
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
                                  alignment: Alignment.center,
                                  height: 300,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        line,
                                        renderLabel('Level'),
                                        line,
                                        AchievementsProgressView(
                                          onTapCallback: null,
                                          imageSize: 120,
                                          achievements: Achievement.getList(
                                              level,
                                              Achievement.levelAchievements()),
                                        ),
                                        line,
                                        renderLabel('Tasks'),
                                        line,
                                        AchievementsProgressView(
                                          onTapCallback: null,
                                          imageSize: 120,
                                          achievements: Achievement.getListTask(
                                            totalTask,
                                            Achievement.getTaskLevel(),
                                          ),
                                        ),
                                        line,
                                        renderLabel('Focus Mode'),
                                        line,
                                        AchievementsProgressView(
                                          onTapCallback: null,
                                          imageSize: 120,
                                          achievements:
                                              Achievement.getFocusModeList(
                                                  this.stats.totalSessions !=
                                                          null
                                                      ? this
                                                          .stats
                                                          .totalSessions!
                                                      : 0,
                                                  Achievement
                                                      .getFocusModeAchievements()),
                                        ),
                                        line,
                                        renderLabel('Hidden'),
                                        line,
                                        AchievementsProgressView(
                                            onTapCallback: null,
                                            imageSize: 120,
                                            achievements:
                                                Achievement.getHiddenList(
                                                    friendAchievementUnlocked,
                                                    this.stats.breakStreak,
                                                    this.stats.haveBecameFirst,
                                                    Achievement
                                                        .getHiddenAchievements()))
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                );
              } else if (widget.status == 'BLOCKED') {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    insetPadding: EdgeInsets.only(top: 290, bottom: 290),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    title: Text(
                      'Unblock User',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'OxygenBold', color: Colors.black),
                    ),
                    content: unblockRequestStatus,
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    insetPadding: EdgeInsets.only(top: 290, bottom: 290),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    title: Text(
                      'Friend Request',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'OxygenBold', color: Colors.black),
                    ),
                    content: widget.requestedPersonID == widget.loggedinpersonID
                        ? cancelRequestStatus
                        : changeRequestStatus,
                  ),
                );
              }
            },
          );
  }
}

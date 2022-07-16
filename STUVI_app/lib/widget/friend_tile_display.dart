import 'package:STUVI_app/Achievements/achievement.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/widget/achievements_progress_view_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    final changeStatus = Column(children: <Widget>[
      Text(
        'Friend request from' +
            '\n' +
            '${friendProfile.firstName! + "" + friendProfile.lastName![0]}',
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
                        ? Container()
                        : changeStatus,
                  ),
                );
              }
            },
          );
  }
}

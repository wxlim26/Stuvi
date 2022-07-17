import 'package:STUVI_app/dto/LeaderboardDto.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/widget/friend_tile_display.dart';
import 'package:STUVI_app/widget/friend_tile_leaderboard_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user_friend.dart';

class LeaderBoardPage extends StatefulWidget {
  UserFriends userFriends;
  UserModel loggedInUser;

  LeaderBoardPage(
      {Key? key, required this.userFriends, required this.loggedInUser})
      : super(key: key);

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  List<LeaderboardDto> friendData = [];
  UserStatsModel stats = UserStatsModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("UserStats")
        .doc(widget.loggedInUser.uid)
        .get()
        .then((DocumentSnapshot doc) {
      UserStatsModel stats = UserStatsModel.fromMap(doc.data());

      friendData.add(
        LeaderboardDto(
            uid: widget.loggedInUser.uid!,
            initials: (widget.loggedInUser.firstName![0] +
                    widget.loggedInUser.lastName![0])
                .toUpperCase(),
            fullName: widget.loggedInUser.firstName! +
                ' ' +
                widget.loggedInUser.lastName!,
            level: (stats.exp! / 500).floor(),
            exp: stats.exp!),
      );
    });
    widget.userFriends.friendList.forEach((element) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(element.uid)
          .get()
          .then(((value) {
        if (mounted) {
          UserModel friendProfile = UserModel.fromMap(value.data());
          FirebaseFirestore.instance
              .collection("UserStats")
              .doc(friendProfile.uid)
              .get()
              .then((DocumentSnapshot doc) {
            if (mounted) {
              UserStatsModel friendStat = UserStatsModel.fromMap(doc.data());
              setState(() {
                friendData.add(LeaderboardDto(
                    uid: friendStat.uid!,
                    initials: (friendProfile.firstName![0] +
                            friendProfile.lastName![0])
                        .toUpperCase(),
                    fullName: friendProfile.firstName! +
                        ' ' +
                        friendProfile.lastName!,
                    level: (friendStat.exp! / 500).floor(),
                    exp: friendStat.exp!));
              });
            }
          });
        }
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    friendData.sort((a, b) => b.exp.compareTo(a.exp));

    Widget requestingList = Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(15),
        itemCount: friendData.length,
        itemBuilder: (context, index) {
          return FriendTileLeaderBoardDisplay(
            index: index,
            leaderboardDto: friendData[index],
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 20),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Leaderboard",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'OxygenBold',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 25,
          ),
        ),
        actions: [],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: requestingList,
        ),
      ),
    );
  }
}

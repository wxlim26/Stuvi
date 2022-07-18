import 'package:STUVI_app/API/firebase_api.dart';
import 'package:STUVI_app/Achievements/achievement.dart';
import 'package:STUVI_app/dto/LeaderboardDto.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/widget/achievements_progress_view_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';

class AchievementSelectorPage extends StatefulWidget {
  final String uid;
  final Function onChangeTitle;
  AchievementSelectorPage({
    Key? key,
    required this.uid,
    required this.onChangeTitle,
  }) : super(key: key);

  @override
  State<AchievementSelectorPage> createState() =>
      _AchievementSelectorPageState();
}

class _AchievementSelectorPageState extends State<AchievementSelectorPage> {
  UserStatsModel userStatsModel = UserStatsModel();
  UserModel loggedInUser = UserModel();
  int totalTask = 0;
  int totalFriends = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (mounted) {
        setState(() {
          loggedInUser = UserModel.fromMap(doc.data());
        });
      }
    });
    FirebaseFirestore.instance
        .collection("UserStats")
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (mounted) {
        setState(() {
          userStatsModel = UserStatsModel.fromMap(doc.data());
        });
      }
    });
    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (mounted) {
        UserFriends userFriends = UserFriends.fromMap(doc.data());
        setState(() {
          totalFriends = userFriends.friendList
              .where((element) => element.status == 'ACCEPTED')
              .length;
        });
      }
    });
    FirebaseApi.getAllTodos(widget.uid).then((QuerySnapshot value) {
      setState(() {
        totalTask = value.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    num calculateDays() {
      DateTime currentDay = DateTime.now();
      DateTime registrationDate =
          DateTime.fromMillisecondsSinceEpoch(loggedInUser.registrationDate);
      return currentDay.difference(registrationDate).inDays;
    }

    final line = Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: Colors.black,
        thickness: 0.5,
      ),
    );
    num exp = userStatsModel.exp != null ? userStatsModel.exp! : 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Achievement",
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
        padding: EdgeInsets.all(10),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Levels",
                style: TextStyle(
                  fontFamily: 'Oxygen',
                  fontSize: 12,
                ),
              ),
              AchievementsProgressView(
                onTapCallback: (String title) {
                  widget.onChangeTitle(title);
                },
                imageSize: 120,
                achievements: Achievement.getList(
                    (exp / 500).floor(), Achievement.levelAchievements()),
              ),
              line,
              Text(
                "Tasks",
                style: TextStyle(
                  fontFamily: 'Oxygen',
                  fontSize: 12,
                ),
              ),
              AchievementsProgressView(
                onTapCallback: (String title) {
                  widget.onChangeTitle(title);
                },
                imageSize: 120,
                achievements: Achievement.getListTask(
                    totalTask, Achievement.getTaskLevel()),
              ),
              line,
              Text(
                "Focus Mode",
                style: TextStyle(
                  fontFamily: 'Oxygen',
                  fontSize: 12,
                ),
              ),
              AchievementsProgressView(
                onTapCallback: (String title) {
                  widget.onChangeTitle(title);
                },
                imageSize: 120,
                achievements: Achievement.getFocusModeList(
                    userStatsModel.totalSessions != null
                        ? userStatsModel.totalSessions!
                        : 0,
                    Achievement.getFocusModeAchievements()),
              ),
              line,
              Text(
                "Login Streak",
                style: TextStyle(
                  fontFamily: 'Oxygen',
                  fontSize: 12,
                ),
              ),
              AchievementsProgressView(
                onTapCallback: (String title) {
                  widget.onChangeTitle(title);
                },
                imageSize: 120,
                achievements: Achievement.getLoginStreakList(
                    calculateDays(), Achievement.getLoginStreakAchievements()),
              ),
              line,
              Text(
                "Hidden",
                style: TextStyle(
                  fontFamily: 'Oxygen',
                  fontSize: 12,
                ),
              ),
              AchievementsProgressView(
                onTapCallback: (String title) {
                  widget.onChangeTitle(title);
                },
                imageSize: 120,
                achievements: Achievement.getHiddenList(
                    totalFriends,
                    userStatsModel.breakStreak,
                    userStatsModel.haveBecameFirst,
                    Achievement.getHiddenAchievements()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

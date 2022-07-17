import 'dart:convert';

import 'package:STUVI_app/API/firebase_api.dart';
import 'package:STUVI_app/Screens/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:STUVI_app/Screens/login_page.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:STUVI_app/widget/achievements_progress_view_widget.dart';
import 'package:STUVI_app/Achievements/achievement.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  UserStatsModel stats = UserStatsModel();
  String? initials;
  num? level;
  num? xp;
  var image;
  int totalTask = 0;

  renderImage() {
    return ClipOval(
      child: Container(
        child: SizedBox(
          width: 120,
          height: 120,
          child: image != null && image != ''
              ? Image.memory(image, fit: BoxFit.cover)
              : CircleAvatar(
                  radius: 20.0,
                  child: Text(
                    '${initials!}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        initials = loggedInUser.firstName![0] + loggedInUser.lastName![0];
        initials = initials!.toUpperCase();
        if (loggedInUser.imageBase64 != null &&
            loggedInUser.imageBase64!.isNotEmpty) {
          image = base64Decode(loggedInUser.imageBase64!);
        }
      });
    });

    FirebaseFirestore.instance
        .collection("UserStats")
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      this.stats = UserStatsModel.fromMap(doc.data());
      setState(() {
        level = (stats.exp! / 500).floor();
        xp = stats.exp!;
      });
    });

    FirebaseApi.getAllTodos(user!.uid).then((QuerySnapshot value) {
      setState(() {
        totalTask = value.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var firstName = loggedInUser.firstName![0];
    //var lastName = loggedInUser.lastName![0];
    //var initials = 'firstName + lastName';

    final appBar = AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "${loggedInUser.firstName} ${loggedInUser.lastName}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: ((context) => SettingsPage()),
              ),
            );
          },
          iconSize: 25,
        ),
      ],
      centerTitle: true,
    );

    bool isLoading = false;
    if (initials == null || level == null) {
      isLoading = true;
    }

    Widget renderTitle() {
      return Text(
        loggedInUser.title.isNotEmpty
            ? 'Title: ${loggedInUser.title}'
            : '', // Replace with ENUM
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }

    return isLoading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: appBar,
            body: ListView(
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2A93D5), Color(0XFF37CAEC)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.9],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      renderImage(),
                      SizedBox(
                        height: 10,
                      ),
                      renderTitle(),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 210,
                        children: [
                          Text(
                            'Level : ${level}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${xp} / ${(level! + 1) * 500}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        child: LinearPercentIndicator(
                          percent: (xp!.toDouble() - (level! * 500)) / 500,
                          //percent: 300 / 500,
                          progressColor: Color(0xFF9FE2BF),
                          backgroundColor: Colors.white,
                          lineHeight: 10.0,
                          barRadius: const Radius.circular(15),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '    Achievements',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Divider(thickness: 2),
                SizedBox(height: 10),
                Container(
                  height: 300,
                  child: AchievementsProgressView(
                    onTapCallback: null,
                    imageSize: 120,
                    achievements: Achievement.getList(
                        level!, Achievement.levelAchievements()),
                  ),
                ),
                Container(
                  height: 300,
                  child: AchievementsProgressView(
                    onTapCallback: null,
                    imageSize: 120,
                    achievements: Achievement.getListTask(
                        totalTask, Achievement.getTaskLevel()),
                  ),
                )
              ],
            ),
          );
  }
}

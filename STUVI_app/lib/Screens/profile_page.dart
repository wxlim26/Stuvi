import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:STUVI_app/Screens/login_screen.dart';
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
        initials = loggedInUser.firstName![0] + loggedInUser.secondName![0];
        initials = initials!.toUpperCase();
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
  }

  @override
  Widget build(BuildContext context) {
    //var firstName = loggedInUser.firstName![0];
    //var secondName = loggedInUser.secondName![0];
    //var initials = 'firstName + secondName';

    bool isLoading = false;
    if (initials == null || level == null) {
      isLoading = true;
    }
    return isLoading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "${loggedInUser.firstName} ${loggedInUser.secondName}",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  height: 300,
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
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 50.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          child: Text(
                            initials!,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Title: Recruit', // Replace with ENUM
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
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
                          progressColor: Colors.greenAccent,
                          backgroundColor: Colors.white,
                          lineHeight: 10.0,
                          barRadius: const Radius.circular(15),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ActionChip(
                        backgroundColor: Color(0xFF3FC5F0),
                        label: Text(
                          "Logout",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          logout(context);
                        },
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
                    achievements: Achievement.getList(
                        //level!
                        level!,
                        Achievement.levelAchievements()),
                  ),
                )
              ],
            ),
          );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => LoginScreen())));
  }
}

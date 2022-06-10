import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:STUVI_app/Screens/login_screen.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/model/user_stats_model.dart';

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
              backgroundColor: Color(0xFF3FC5F0),
              title: Text("Home Page"),
              centerTitle: true,
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent.shade400],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.5, 0.9],
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
                          child: Text(initials!),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "${loggedInUser.firstName} ${loggedInUser.secondName}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Level : ${level}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
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

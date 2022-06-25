import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/provider/todos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class PercentageIndicatorWidget extends StatefulWidget {
  const PercentageIndicatorWidget({Key? key}) : super(key: key);

  @override
  State<PercentageIndicatorWidget> createState() =>
      _PercentageIndicatorWidgetState();
}

class _PercentageIndicatorWidgetState extends State<PercentageIndicatorWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? initials;

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
      });
    });
  }

  DateTime getGMTPlusEightTime() {
    tz.initializeTimeZones();
    final DateTime now = DateTime.now();
    final pacificTimeZone = tz.getLocation('Asia/Singapore');
    return tz.TZDateTime.from(now, pacificTimeZone);
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todosCompleted = provider.todosCompleted;
    final todos = provider.todos;
    int totalTasks = todos.length + todosCompleted.length;
    double percentCompleted =
        totalTasks != 0 ? todosCompleted.length / totalTasks * 100 : 0;
    double percentCompletedRounded =
        double.parse((percentCompleted).toStringAsFixed(1));

    String greeting() {
      // var hour = getGMTPlusEightTime().hour;
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good Morning';
      }
      if (hour < 17) {
        return 'Good Afternoon';
      }
      return 'Good Evening';
    }

    final greetingText = Text(
      greeting() + "," + " ${loggedInUser.firstName}.👋",
      style: TextStyle(
          fontFamily: 'OxygenBold', color: Colors.white, fontSize: 18),
    );

    final secondText = Text(
      'What would you like to do today?',
      style: TextStyle(fontFamily: 'Oxygen', color: Colors.white, fontSize: 15),
    );

    final taskCompletedText = Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        '${todosCompleted.length.toString()}/${totalTasks} tasks completed!',
        style:
            TextStyle(fontFamily: 'Oxygen', color: Colors.white, fontSize: 15),
      ),
    );

    final progressIndicator = Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.25,
      child: LiquidCircularProgressIndicator(
        value: percentCompletedRounded / 100,
        valueColor: AlwaysStoppedAnimation(
          Color(0xFF9FE2BF),
        ),
        backgroundColor: Colors.transparent,
        borderWidth: 2,
        borderColor: Colors.white,
        direction: Axis.vertical,
        center: Text(
          '${percentCompletedRounded}%',
          style: TextStyle(
            fontFamily: 'OxygenBold',
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );

    final progress = Row(
      children: <Widget>[progressIndicator, taskCompletedText],
    );

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/test.jpg"),
              fit: BoxFit.fitWidth,
            ),
            gradient: LinearGradient(
              colors: [
                Color(0xFF2A93D5),
                Color(0XFF37CAEC),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.9],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    greetingText,
                    SizedBox(height: 15),
                    secondText,
                    SizedBox(height: 15),
                    progress,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

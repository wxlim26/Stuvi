import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/provider/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:STUVI_app/widget/done_button_widget.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:async';

import '../widget/play_button_widget.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  UserStatsModel stats = UserStatsModel();

  Duration duration = Duration();
  Timer? timer;
  bool paused = true;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    FirebaseFirestore.instance
        .collection("UserStats")
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      this.stats = UserStatsModel.fromMap(doc.data());
      StatsProvider().shouldResetDay(this.stats, DateTime.now());
      setState(() {});
    });
  }

  void addTime() {
    // Adds 1 second every second.
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void resetTimer() {
    setState(() => duration = Duration());
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      resetTimer();
    }
    // every second run addTime method.
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 5,
      backgroundColor: Colors.white,
      title: Text(
        'Focus Mode',
        style: TextStyle(
            fontSize: 20, color: Colors.black, fontFamily: 'OxygenBold'),
      ),
      centerTitle: true,
    );

    final statisticsText = Text(
      'My Personal Statistics',
      style: TextStyle(
          color: Colors.white, fontFamily: 'OxygenBold', fontSize: 20),
    );

    final totalSessionText = Text(
      '${stats.totalSessions}' + '\n' + 'Total' + '\n' + 'Sessions',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontFamily: 'Oxygen', fontSize: 20),
    );

    int minutes = 0;
    if (stats.secondsSpendToday != null) {
      minutes = (stats.secondsSpendToday! / 60).floor();
    }
    String minutesText = minutes == 1 ? 'Minute' : 'Minutes';
    final totalMinutesText = Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        '${minutes}' + '\n' + 'Total' + '\n' + minutesText,
        textAlign: TextAlign.center,
        style:
            TextStyle(color: Colors.white, fontFamily: 'Oxygen', fontSize: 20),
      ),
    );

    final totalStreakText = Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        '${stats.focusModeStreak}' + '\n' + 'Day' + '\n' + 'Streak',
        textAlign: TextAlign.center,
        style:
            TextStyle(color: Colors.white, fontFamily: 'Oxygen', fontSize: 20),
      ),
    );

    final statisticsRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[totalSessionText, totalMinutesText, totalStreakText],
    );

    final line = Padding(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Divider(
          color: Colors.white,
          thickness: 1,
        ));

    Widget buildButtons() {
      final isRunning = timer == null ? false : timer!.isActive;
      final isCompleted = duration.inSeconds == 0;
      return isRunning || !isCompleted
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      paused = !paused;
                    });
                    if (isRunning) {
                      stopTimer(resets: false);
                    } else {
                      startTimer(resets: false);
                    }
                  },
                  backgroundColor: Colors.white,
                  child:
                      //paused ? Icon(Icons.pause) : Icon(Icons.play_arrow_rounded),
                      Icon(
                          (paused == true)
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          color: Color(0xFF31AFE1)),
                ),
                const SizedBox(width: 12),
                DoneButtonWidget(onClicked: () {
                  StatsProvider().increaseExpTimer(stats, duration.inSeconds);
                  StatsProvider().increaseTotalSessions(stats, DateTime.now());
                  StatsProvider()
                      .increaseSecondsToday(stats, duration.inSeconds);
                  stopTimer();
                  showDialog(
                      context: context, builder: (context) => AlertDialog());
                })
              ],
            )
          : PlayButtonWidget(
              onClicked: () {
                startTimer();
              },
            );
    }

    Widget buildTime() {
      String twoDigits(int n) =>
          n.toString().padLeft(2, '0'); // Ensure 2 digits
      final hours = twoDigits(duration.inHours.remainder(60));
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));

      return Column(
        children: <Widget>[
          SizedBox(height: 100),
          Text(
            '$hours:$minutes:$seconds',
            style: TextStyle(
                fontFamily: "OxygenLight", fontSize: 60, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'Time Spent' + '\n' 'Being Focused',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "OxygenLight", fontSize: 20, color: Colors.white),
          ),
        ],
      );
    }

    // For a rounded circle
    Widget buildTimer() {
      return SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: duration.inSeconds.remainder(60) / 60,
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            ),
            Center(child: buildTime()),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF3FC5F0),
      appBar: appBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2A93D5),
              Color(0XFF37CAEC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              statisticsText,
              SizedBox(height: 20),
              statisticsRow,
              SizedBox(height: 20),
              line,
              SizedBox(height: 30),
              buildTimer(),
              SizedBox(height: 30),
              buildButtons(),
              SizedBox(height: 75)
            ],
          ),
        ),
      ),
    );
  }
}

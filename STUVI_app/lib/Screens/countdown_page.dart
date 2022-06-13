import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/provider/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:STUVI_app/widget/done_button_widget.dart';
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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFF3FC5F0),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Focus Mode',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [buildTimer(), SizedBox(height: 40), buildButtons()],
          ),
        ),
      );

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
                        color: Color(0xFF3FC5F0)),
              ),
              const SizedBox(width: 12),
              DoneButtonWidget(onClicked: () {
                StatsProvider().increaseExp(stats, duration.inSeconds);
                stopTimer();
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
    String twoDigits(int n) => n.toString().padLeft(2, '0'); // Ensure 2 digits
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$hours:$minutes:$seconds',
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 60, color: Colors.white),
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
            backgroundColor: Colors.blue,
          ),
          Center(child: buildTime()),
        ],
      ),
    );
  }
}

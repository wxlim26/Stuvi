import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DailyStreakWidget extends StatefulWidget {
  final UserStatsModel stats;

  const DailyStreakWidget({Key? key, required this.stats}) : super(key: key);

  @override
  State<DailyStreakWidget> createState() => _DailyStreakWidgetState();
}

class _DailyStreakWidgetState extends State<DailyStreakWidget> {
  @override
  Widget build(BuildContext context) {
    final tasksCompleted = Text(
      'Tasks Completion Streak',
      style: TextStyle(
          fontFamily: 'OxygenBold', fontSize: 20, color: Colors.white),
    );

    final longestStreak = Text(
      '🔥 Longest Streak : ${widget.stats.longestStreakTask}',
      style: TextStyle(fontFamily: 'Oxygen', fontSize: 15, color: Colors.white),
    );

    final currentStreak = Text(
      '📝 Current Streak : ${widget.stats.currentStreakTask}',
      style: TextStyle(fontFamily: 'Oxygen', fontSize: 15, color: Colors.white),
    );

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/test2.jpg"),
              fit: BoxFit.cover,
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
                    tasksCompleted,
                    SizedBox(height: 15),
                    longestStreak,
                    SizedBox(height: 8),
                    currentStreak
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

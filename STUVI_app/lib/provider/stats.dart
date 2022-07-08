import 'package:flutter/cupertino.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/API/user_stats.dart';

class StatsProvider extends ChangeNotifier {
  void increaseExpTimer(UserStatsModel stats, int seconds) {
    UserStats.updateExp(
        stats, (seconds / 3600).floor() * 100 + (seconds / 60).floor() * 10);
  }

  void increaseExpTasks(UserStatsModel stats) {
    UserStats.updateExp(stats, 50);
  }

  void decreaseExpTasks(UserStatsModel stats) {
    UserStats.updateExp(stats, -50);
  }

  void updateExpTasksList(UserStatsModel stats, int listLength) {
    UserStats.updateExp(stats, listLength);
  }

  void increaseTotalSessions(UserStatsModel stats, DateTime today) {
    DateTime initialDateTime = DateTime.fromMillisecondsSinceEpoch(
        stats.secondsSpendLastRecordedDate!.toInt());
    bool shouldUpdateStreak = today.difference(initialDateTime).inDays == 1;
    UserStats.updateTotalSessions(stats, shouldUpdateStreak);
  }

  void increaseSecondsToday(UserStatsModel stats, int seconds) {
    UserStats.updateSecondsToday(stats, seconds);
  }

  void shouldResetDay(UserStatsModel stats, DateTime today) {
    DateTime initialDateTime = DateTime.fromMillisecondsSinceEpoch(
        stats.secondsSpendLastRecordedDate!.toInt());
    int initialYear = initialDateTime.year;
    int initialMonth = initialDateTime.month;
    int initialDate = initialDateTime.day;
    int todayYear = today.year;
    int todayMonth = today.month;
    int todayDate = today.day;
    if (initialYear != todayYear ||
        initialMonth != todayMonth ||
        initialDate != todayDate) {
      bool shouldResetStreak = today.difference(initialDateTime).inDays > 1;
      UserStats.resetDateTime(stats, shouldResetStreak);
    }
  }
}

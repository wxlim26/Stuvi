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
}

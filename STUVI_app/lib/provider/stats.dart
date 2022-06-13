import 'package:flutter/cupertino.dart';
import 'package:STUVI_app/model/user_stats_model.dart';

import 'package:STUVI_app/API/user_stats.dart';

class StatsProvider extends ChangeNotifier {
  void increaseExp(UserStatsModel stats, int seconds) =>
      UserStats.updateExp(stats, (seconds / 60).floor());
}

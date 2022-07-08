import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:STUVI_app/model/user_stats_model.dart';

class UserStats {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  static Future updateExp(UserStatsModel userStats, int exp) async {
    if (userStats.exp != null) {
      userStats.exp = userStats.exp! + exp;
    }
    final docUserStats =
        FirebaseFirestore.instance.collection('UserStats').doc(userStats.uid);

    await docUserStats.update(userStats.toMap());
  }

  static Future updateTotalSessions(
      UserStatsModel userStats, bool shouldUpdateStreak) async {
    if (userStats.totalSessions != null) {
      userStats.totalSessions = userStats.totalSessions! + 1;
    } else {
      userStats.totalSessions = 1;
    }

    if (shouldUpdateStreak) {
      userStats.focusModeStreak = userStats.focusModeStreak! + 1;
    }
    userStats.secondsSpendLastRecordedDate =
        DateTime.now().toUtc().millisecondsSinceEpoch;
    final docUserStats =
        FirebaseFirestore.instance.collection('UserStats').doc(userStats.uid);

    await docUserStats.update(userStats.toMap());
  }

  static Future updateSecondsToday(
      UserStatsModel userStats, int seconds) async {
    if (userStats.secondsSpendToday != null) {
      userStats.secondsSpendToday = userStats.secondsSpendToday! + seconds;
    }
    final docUserStats =
        FirebaseFirestore.instance.collection('UserStats').doc(userStats.uid);

    await docUserStats.update(userStats.toMap());
  }

  static Future resetDateTime(
      UserStatsModel userStats, bool shouldResetStreak) async {
    userStats.secondsSpendToday = 0;

    if (shouldResetStreak) {
      userStats.focusModeStreak = 0;
    }

    final docUserStats =
        FirebaseFirestore.instance.collection('UserStats').doc(userStats.uid);

    await docUserStats.update(userStats.toMap());
  }
}

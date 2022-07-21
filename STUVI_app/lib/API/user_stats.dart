import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_model.dart';
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

    if (!userStats.haveBecameFirst) {
      bool stillNotFirst = false;
      DocumentSnapshot<Map<String, dynamic>> userFriend =
          await FirebaseFirestore.instance
              .collection("userFriends")
              .doc(userStats.uid)
              .get();

      UserFriends userFriends = UserFriends.fromMap(userFriend.data());
      List<String?> friendList =
          userFriends.friendList.map((e) => e.uid).toList();

      for (int i = 0; i < friendList.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> friendData =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(friendList[i])
                .get();

        UserModel friendUser = UserModel.fromMap(friendData.data());
        DocumentSnapshot<Map<String, dynamic>> friendStatsData =
            await FirebaseFirestore.instance
                .collection("UserStats")
                .doc(friendUser.uid)
                .get();

        UserStatsModel userStatsModel =
            UserStatsModel.fromMap(friendStatsData.data());
        if (userStats.exp! < userStatsModel.exp!) {
          stillNotFirst = true;
        }
      }

      if (!stillNotFirst) {
        userStats.haveBecameFirst = true;
      }
    }
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
      userStats.breakStreak = true;
    }

    final docUserStats =
        FirebaseFirestore.instance.collection('UserStats').doc(userStats.uid);

    await docUserStats.update(userStats.toMap());
  }
}

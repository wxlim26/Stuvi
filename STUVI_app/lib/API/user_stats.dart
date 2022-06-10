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
}

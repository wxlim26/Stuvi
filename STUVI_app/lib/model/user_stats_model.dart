class UserStatsModel {
  String? uid;
  num? exp;
  num? totalSessions;
  num? secondsSpendToday;
  num? secondsSpendLastRecordedDate;
  num? focusModeStreak;

  UserStatsModel(
      {this.uid,
      this.exp,
      this.totalSessions,
      this.secondsSpendToday,
      this.secondsSpendLastRecordedDate,
      this.focusModeStreak});

  // receiving data from server
  factory UserStatsModel.fromMap(map) {
    return UserStatsModel(
        uid: map['uid'],
        exp: map['exp'],
        totalSessions: map['totalSessions'],
        secondsSpendToday: map['secondsSpendToday'],
        secondsSpendLastRecordedDate: map['secondsSpendLastRecordedDate'],
        focusModeStreak: map['focusModeStreak']);
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'exp': exp,
      'totalSessions': totalSessions,
      'secondsSpendToday': secondsSpendToday,
      'secondsSpendLastRecordedDate': secondsSpendLastRecordedDate,
      'focusModeStreak': focusModeStreak
    };
  }
}

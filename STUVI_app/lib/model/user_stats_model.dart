class UserStatsModel {
  String? uid;
  num? exp;
  num? totalSessions;
  num? secondsSpendToday;
  num? secondsSpendLastRecordedDate;
  num? focusModeStreak;
  num? longestStreakTask;
  num? currentStreakTask;
  num? lastDateStreak;

  UserStatsModel(
      {this.uid,
      this.exp,
      this.totalSessions,
      this.secondsSpendToday,
      this.secondsSpendLastRecordedDate,
      this.focusModeStreak,
      this.longestStreakTask,
      this.currentStreakTask,
      this.lastDateStreak});

  // receiving data from server
  factory UserStatsModel.fromMap(map) {
    return UserStatsModel(
        uid: map['uid'],
        exp: map['exp'],
        totalSessions: map['totalSessions'],
        secondsSpendToday: map['secondsSpendToday'],
        secondsSpendLastRecordedDate: map['secondsSpendLastRecordedDate'],
        focusModeStreak: map['focusModeStreak'],
        longestStreakTask: map['longestStreakTask'],
        currentStreakTask: map['currentStreakTask'],
        lastDateStreak: map['lastDateStreak']);
  }

  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'exp': exp,
      'totalSessions': totalSessions,
      'secondsSpendToday': secondsSpendToday,
      'secondsSpendLastRecordedDate': secondsSpendLastRecordedDate,
      'focusModeStreak': focusModeStreak,
      'longestStreakTask': longestStreakTask,
      'currentStreakTask': currentStreakTask,
      'lastDateStreak': lastDateStreak,
    };
  }
}

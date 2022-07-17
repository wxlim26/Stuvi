class LeaderboardDto {
  String uid;
  String fullName;
  String initials;
  int level;
  num exp;

  LeaderboardDto({
    this.uid = '',
    this.fullName = '',
    this.level = 1,
    this.initials = '',
    this.exp = 0,
  });
}

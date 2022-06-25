// import 'package:flutter/material.dart';

class Achievement {
  final String name;
  final String iconPath;
  final String condition;
  bool achieved;

  Achievement({
    required this.name,
    required this.iconPath,
    required this.condition,
    this.achieved = false,
  });

  Achievement setAchieved() {
    return Achievement(
        name: this.name,
        iconPath: this.iconPath,
        condition: this.condition,
        achieved: true);
  }

  // INSTANTIATE THE LIST OF ACHIEVEMENTS RESET TO FALSE AFTER
  static List<Achievement> levelAchievements() {
    return [
      // NOVICE
      Achievement(
          name: 'Novice I',
          iconPath: 'assets/achievements_icon/1.png',
          condition: 'Rewarded after reaching level 1',
          achieved: false),
      Achievement(
          name: 'Novice II',
          iconPath: 'assets/achievements_icon/2.png',
          condition: 'Rewarded after reaching level 5',
          achieved: false),
      Achievement(
          name: 'Novice III',
          iconPath: 'assets/achievements_icon/3.png',
          condition: 'Rewarded after reaching level 10',
          achieved: false),
      // APPRENTICE
      Achievement(
          name: 'Apprentice I',
          iconPath: 'assets/achievements_icon/4.png',
          condition: 'Rewarded after reaching level 20',
          achieved: false),
      Achievement(
          name: 'Apprentice II',
          iconPath: 'assets/achievements_icon/5.png',
          condition: 'Rewarded after reaching level 30',
          achieved: false),
      Achievement(
          name: 'Apprentice III',
          iconPath: 'assets/achievements_icon/6.png',
          condition: 'Rewarded after reaching level 40',
          achieved: false),
      // PRACTITIONER
      Achievement(
          name: 'Practitioner I',
          iconPath: 'assets/achievements_icon/7.png',
          condition: 'Rewarded after reaching level 50',
          achieved: false),
      Achievement(
          name: 'Practitioner II',
          iconPath: 'assets/achievements_icon/8.png',
          condition: 'Rewarded after reaching level 60',
          achieved: false),
      Achievement(
          name: 'Practitioner III',
          iconPath: 'assets/achievements_icon/9.png',
          condition: 'Rewarded after reaching level 70',
          achieved: false),
      // EXPERT
      Achievement(
          name: 'Expert I',
          iconPath: 'assets/achievements_icon/10.png',
          condition: 'Rewarded after reaching level 80',
          achieved: false),
      Achievement(
          name: 'Expert II',
          iconPath: 'assets/achievements_icon/11.png',
          condition: 'Rewarded after reaching level 90',
          achieved: false),
      Achievement(
          name: 'Expert III',
          iconPath: 'assets/achievements_icon/12.png',
          condition: 'Rewarded after reaching level 100',
          achieved: false),
    ];
  }

  static List<Achievement> getList(
      num level, List<Achievement> achievmentList) {
    if (level == 0) {
      return achievmentList;
    } else if (level >= 1 && level < 5) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      return newList;
    } else if (level >= 5 && level < 10) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      return newList;
    } else if (level >= 10 && level < 20) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      return newList;
    } else if (level >= 20 && level < 30) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      return newList;
    } else if (level >= 30 && level < 40) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      newList[4] = newList[4].setAchieved();
      return newList;
    } else if (level >= 40 && level < 50) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      newList[4] = newList[4].setAchieved();
      newList[5] = newList[5].setAchieved();
      return newList;
    } else if (level >= 50 && level < 60) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      newList[4] = newList[4].setAchieved();
      newList[5] = newList[5].setAchieved();
      newList[6] = newList[6].setAchieved();
      return newList;
    } else if (level >= 60 && level < 70) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      newList[4] = newList[4].setAchieved();
      newList[5] = newList[5].setAchieved();
      newList[6] = newList[6].setAchieved();
      newList[7] = newList[7].setAchieved();
      return newList;
    } else if (level >= 70 && level < 80) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      newList[4] = newList[4].setAchieved();
      newList[5] = newList[5].setAchieved();
      newList[6] = newList[6].setAchieved();
      newList[7] = newList[7].setAchieved();
      newList[8] = newList[8].setAchieved();
      return newList;
    } else if (level >= 80 && level < 90) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      newList[4] = newList[4].setAchieved();
      newList[5] = newList[5].setAchieved();
      newList[6] = newList[6].setAchieved();
      newList[7] = newList[7].setAchieved();
      newList[8] = newList[8].setAchieved();
      newList[9] = newList[9].setAchieved();
      return newList;
    } else if (level >= 90 && level < 100) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      newList[4] = newList[4].setAchieved();
      newList[5] = newList[5].setAchieved();
      newList[6] = newList[6].setAchieved();
      newList[7] = newList[7].setAchieved();
      newList[8] = newList[8].setAchieved();
      newList[9] = newList[9].setAchieved();
      newList[10] = newList[10].setAchieved();
      return newList;
    } else if (level >= 100) {
      List<Achievement> newList = achievmentList;
      newList[0] = newList[0].setAchieved();
      newList[1] = newList[1].setAchieved();
      newList[2] = newList[2].setAchieved();
      newList[3] = newList[3].setAchieved();
      newList[4] = newList[4].setAchieved();
      newList[5] = newList[5].setAchieved();
      newList[6] = newList[6].setAchieved();
      newList[7] = newList[7].setAchieved();
      newList[8] = newList[8].setAchieved();
      newList[9] = newList[9].setAchieved();
      newList[10] = newList[10].setAchieved();
      newList[11] = newList[11].setAchieved();
      return newList;
    } else {
      return achievmentList;
    }
  }
}

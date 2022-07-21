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

  static List<Achievement> getTaskLevel() {
    return [
      // NOVICE
      Achievement(
          name: 'Your First',
          iconPath: 'assets/achievements_icon/13.png',
          condition: 'A great start to be the very best!',
          achieved: false),
      Achievement(
          name: 'Decennium',
          iconPath: 'assets/achievements_icon/14.png',
          condition:
              "A day's worth of tasks, but the title \n says otherwise...keep up the momentum!",
          achieved: false),
      Achievement(
          name: 'Centenniel',
          iconPath: 'assets/achievements_icon/15.png',
          condition:
              'You are on your way to beating the \n age of the oldest person living on earth!',
          achieved: false),
      Achievement(
          name: 'Quincentenary',
          iconPath: 'assets/achievements_icon/16.png',
          condition: 'Hmmmm... who knew this word evver existed anyways?',
          achieved: false),
      Achievement(
          name: 'Millenium',
          iconPath: 'assets/achievements_icon/17.png',
          condition:
              "Having come so far you now \n officially hold the title of STUVI's task-maniac",
          achieved: false),
    ];
  }

  static List<Achievement> getFocusModeAchievements() {
    return [
      // NOVICE
      Achievement(
          name: 'Golden Hour',
          iconPath: 'assets/achievements_icon/18.png',
          condition: 'The start of a magical journey!',
          achieved: false),
      Achievement(
          name: 'Portal',
          iconPath: 'assets/achievements_icon/19.png',
          condition: "Into the abyss!",
          achieved: false),
      Achievement(
          name: 'Hyperbolic Time Chamber',
          iconPath: 'assets/achievements_icon/20.png',
          condition: 'Are you secretly a time traveler?',
          achieved: false),
      Achievement(
          name: 'Timeless',
          iconPath: 'assets/achievements_icon/21.png',
          condition: 'A tale as old as time',
          achieved: false),
      Achievement(
          name: 'BlackHole',
          iconPath: 'assets/achievements_icon/22.png',
          condition: "What is time anymore?",
          achieved: false),
    ];
  }

  static List<Achievement> getLoginStreakAchievements() {
    return [
      // NOVICE
      Achievement(
          name: 'Epic',
          iconPath: 'assets/achievements_icon/23.png',
          condition: 'Logged in for 100 days',
          achieved: false),
      Achievement(
          name: 'Legendary',
          iconPath: 'assets/achievements_icon/24.png',
          condition: "Logged in for 500 days",
          achieved: false),
      Achievement(
          name: 'Mythical',
          iconPath: 'assets/achievements_icon/25.png',
          condition: 'Logged in for 1000 days',
          achieved: false),
    ];
  }

  static List<Achievement> getHiddenAchievements() {
    return [
      // NOVICE
      Achievement(
          name: 'Socialite',
          iconPath: 'assets/achievements_icon/26.png',
          condition: 'Hello Popular Person',
          achieved: false),
      Achievement(
          name: 'Day Off',
          iconPath: 'assets/achievements_icon/27.png',
          condition: "It's always good to have a break!",
          achieved: false),
      Achievement(
          name: 'Champion',
          iconPath: 'assets/achievements_icon/29.png',
          condition: "Congratulations, how does \n it feel to be at the top?",
          achieved: false),
    ];
  }

  static List<Achievement> getListTask(
      num totalTask, List<Achievement> taskList) {
    List<Achievement> newList = [];
    if (totalTask > 0) {
      newList.add(taskList[0].setAchieved());
    }
    if (totalTask >= 10) {
      newList.add(taskList[1].setAchieved());
    }
    if (totalTask >= 100) {
      newList.add(taskList[2].setAchieved());
    }
    if (totalTask >= 500) {
      newList.add(taskList[3].setAchieved());
    }
    if (totalTask >= 1000) {
      newList.add(taskList[4].setAchieved());
    }
    return newList;
  }

  static List<Achievement> getList(
      num level, List<Achievement> achievmentList) {
    List<Achievement> newList = [];
    if (level >= 1) {
      newList.add(achievmentList[0].setAchieved());
    }
    if (level >= 5) {
      newList.add(achievmentList[1].setAchieved());
    }
    if (level >= 10) {
      newList.add(achievmentList[2].setAchieved());
    }
    if (level >= 20) {
      newList.add(achievmentList[3].setAchieved());
    }
    if (level >= 30) {
      newList.add(achievmentList[4].setAchieved());
    }
    if (level >= 40) {
      newList.add(achievmentList[5].setAchieved());
    }
    if (level >= 50) {
      newList.add(achievmentList[6].setAchieved());
    }
    if (level >= 60) {
      newList.add(achievmentList[7].setAchieved());
    }
    if (level >= 70) {
      newList.add(achievmentList[8].setAchieved());
    }
    if (level >= 80) {
      newList.add(achievmentList[9].setAchieved());
    }
    if (level >= 900) {
      newList.add(achievmentList[10].setAchieved());
    }
    if (level >= 100) {
      newList.add(achievmentList[11].setAchieved());
    }
    return newList;
  }

  static List<Achievement> getFocusModeList(
      num session, List<Achievement> focusModeList) {
    List<Achievement> newList = [];
    if (session > 0) {
      newList.add(focusModeList[0].setAchieved());
    }
    if (session >= 10) {
      newList.add(focusModeList[1].setAchieved());
    }
    if (session >= 100) {
      newList.add(focusModeList[2].setAchieved());
    }
    if (session >= 500) {
      newList.add(focusModeList[3].setAchieved());
    }
    if (session >= 1000) {
      newList.add(focusModeList[4].setAchieved());
    }
    return newList;
  }

  static List<Achievement> getLoginStreakList(
      num loginDays, List<Achievement> loginStreakList) {
    List<Achievement> newList = [];
    if (loginDays >= 100) {
      newList.add(loginStreakList[0].setAchieved());
    }
    if (loginDays >= 500) {
      newList.add(loginStreakList[1].setAchieved());
    }
    if (loginDays >= 1000) {
      newList.add(loginStreakList[2].setAchieved());
    }
    return newList;
  }

  static List<Achievement> getHiddenList(num totalFriends, bool breakStreak,
      bool haveBecameTheFirst, List<Achievement> hiddenList) {
    List<Achievement> newList = [];
    if (totalFriends >= 20) {
      newList.add(hiddenList[0].setAchieved());
    }
    if (breakStreak) {
      newList.add(hiddenList[1].setAchieved());
    }
    if (haveBecameTheFirst) {
      newList.add(hiddenList[2].setAchieved());
    }
    return newList;
  }
}

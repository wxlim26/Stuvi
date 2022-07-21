import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:STUVI_app/Achievements/achievement.dart';

class AchievementsProgressView extends StatelessWidget {
  final double imageSize;
  final List<Achievement> achievements;
  final Function? onTapCallback;
  const AchievementsProgressView(
      {Key? key,
      required this.onTapCallback,
      required this.achievements,
      required this.imageSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 5.0,
        spacing: 5.0,
        children: achievements
            .map((ach) => AchievementProgressView(
                  achievement: ach,
                  imageSize: imageSize,
                  onTapCallback: onTapCallback,
                ))
            .toList(),
      ),
    );
  }
}

class AchievementProgressView extends StatelessWidget {
  final Achievement achievement;
  final double imageSize;
  final Function? onTapCallback;
  const AchievementProgressView({
    Key? key,
    required this.achievement,
    required this.imageSize,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return achievement.achieved
        ? Column(
            children: [
              /*Text(
                '${achievement.name} unlocked',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              */
              InkWell(
                onTap: () async {
                  if (onTapCallback != null) {
                    onTapCallback!(achievement.name);
                    Navigator.pop(context);
                  } else {
                    await showDialog(
                      context: context,
                      builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new SimpleDialog(
                            title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Achievement Unlocked'),
                                ]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            children: [
                              SizedBox(
                                height: 150,
                                child: Image.asset(achievement.iconPath,
                                    fit: BoxFit.contain),
                              ),
                              SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('${achievement.condition}',
                                        textAlign: TextAlign.center)
                                  ]),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Ink(
                  height: imageSize,
                  child: Image.asset(achievement.iconPath, fit: BoxFit.contain),
                ),
              ),
              //Text('Unlocked'),
            ],
          )
        : SizedBox(
            height: 100,
            width: 100,
          );
  }
}

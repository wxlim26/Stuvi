import 'package:flutter/material.dart';
import 'package:STUVI_app/Achievements/achievement.dart';

class AchievementsProgressView extends StatelessWidget {
  final List<Achievement> achievements;
  const AchievementsProgressView({Key? key, required this.achievements})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 5.0,
        spacing: 5.0,
        children: achievements
            .map((ach) => AchievementProgressView(achievement: ach))
            .toList(),
      ),
    );
  }
}

class AchievementProgressView extends StatelessWidget {
  final Achievement achievement;
  const AchievementProgressView({Key? key, required this.achievement})
      : super(key: key);

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
                                children: [Text('${achievement.condition}')]),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                child: Ink(
                  height: 100,
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

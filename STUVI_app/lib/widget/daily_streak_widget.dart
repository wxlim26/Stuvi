import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DailyStreakWidget extends StatefulWidget {
  const DailyStreakWidget({Key? key}) : super(key: key);

  @override
  State<DailyStreakWidget> createState() => _DailyStreakWidgetState();
}

class _DailyStreakWidgetState extends State<DailyStreakWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('In Progress 🚧'),
    )
        // body: Center(
        //   child: Container(
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //         image: AssetImage("assets/Background.png"),
        //         fit: BoxFit.cover,
        //       ),
        //       gradient: LinearGradient(
        //         colors: [
        //           Color(0xFF2A93D5),
        //           Color(0XFF37CAEC),
        //         ],
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //         stops: [0.1, 0.9],
        //       ),
        //       borderRadius: BorderRadius.circular(30),
        //     ),
        //     padding: EdgeInsets.all(15),
        //     child: Row(
        //       children: [
        //         SizedBox(width: 20),
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
        //               SizedBox(height: 15),
        //               SizedBox(height: 15),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}

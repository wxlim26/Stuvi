import 'package:flutter/material.dart';

//USED FOR FOCUS MODE

class PlayButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const PlayButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: onClicked,
        child: Icon(Icons.play_arrow_rounded, color: Color(0xFF3FC5F0)),
      );
}

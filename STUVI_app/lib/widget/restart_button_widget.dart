import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RestartButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const RestartButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: onClicked,
        child: Icon(CupertinoIcons.restart, color: Color(0xFF31AFE1)),
      );
}

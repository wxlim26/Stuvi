import 'package:flutter/material.dart';

class OnHoldListWidget extends StatelessWidget {
  final Function(TextEditingController) onShowEmojiKeyboard;

  const OnHoldListWidget({Key? key, required this.onShowEmojiKeyboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('In Progress 🚧')));
  }
}

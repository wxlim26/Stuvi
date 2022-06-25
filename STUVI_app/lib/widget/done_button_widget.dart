import 'package:flutter/material.dart';

// Used for FOCUS MODE

class DoneButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const DoneButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: onClicked,
        child: Icon(Icons.done, color: Color(0xFF31AFE1)),
      );
}

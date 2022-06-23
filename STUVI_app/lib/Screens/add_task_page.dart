import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:STUVI_app/Screens/home_screen.dart';

class AddTaskPage extends StatefulWidget {
  final String title;
  final String startTime;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedStartTime;
  final ValueChanged<String> onChangedDescription;
  final VoidCallback onSavedToDo;

  const AddTaskPage({
    Key? key,
    this.title = '',
    this.startTime = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedStartTime,
    required this.onChangedDescription,
    required this.onSavedToDo,
  }) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);

  void timePicker() async {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        timeOfDay = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 5,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontFamily: 'OxygenBold'),
      title: Text(
        'Create Task',
      ),
    );

    final titleText = Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Title',
            style: TextStyle(
                fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );

    Widget buildTitle() => Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            autofocus: false,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            initialValue: widget.title,
            onChanged: widget.onChangedTitle,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBEBEB),
              prefixIcon: Icon(Icons.title_rounded),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Enter Title",
              hintStyle: TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        );

    final timeText = Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Time',
            style: TextStyle(
                fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );

    Widget buildTime() => Padding(
          padding: const EdgeInsets.only(left: 15),
          child: TextFormField(
            readOnly: true,
            autofocus: false,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            initialValue: widget.startTime,
            onChanged: widget.onChangedStartTime,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBEBEB),
              prefixIcon: Icon(Icons.access_time_filled),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Enter Time",
              hintStyle: TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        );

    // Widget buildTimeButton = MaterialButton(
    //   onPressed: timePicker(),
    //   color: Color(0xFFEBEBEB),
    //   child: Icon(
    //     Icons.arrow_drop_down,
    //     color: Color(0xFF808080),
    //   ),
    // );

    // Widget buildTimeRow() => Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Container(
    //             width: MediaQuery.of(context).size.width * 0.8,
    //             child: buildTime()),
    //         Container(
    //           width: MediaQuery.of(context).size.width * 0.2,
    //           height: MediaQuery.of(context).size.height * 0.055,
    //           child: Padding(
    //               padding: const EdgeInsets.only(left: 5, right: 15),
    //               child: buildTimeButton),
    //         ),
    //       ],
    //     );

    final descriptionText = Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
                fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );

    Widget buildDescription() => Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            autofocus: false,
            maxLines: 5,
            textInputAction: TextInputAction.next,
            initialValue: widget.description,
            onChanged: widget.onChangedDescription,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEBEBEB),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Enter Description",
              hintStyle: TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        );

    final buildButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: Color(0xFF31AFE1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width * 0.5,
        onPressed: () {
          widget.onSavedToDo();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }, // Replace with the save to database
        child: Text(
          'Save',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'OxygenBold'),
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appBar,
          SizedBox(height: 20),
          titleText,
          // Text(timeOfDay.format(context).toString()),
          buildTitle(),
          SizedBox(height: 8),
          timeText,
          SizedBox(height: 8),
          // buildTimeRow(),
          SizedBox(height: 8),
          descriptionText,
          SizedBox(height: 8),
          buildDescription(),
          SizedBox(height: 15),
          buildButton,
        ],
      ),
    );
  }
}
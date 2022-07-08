import 'package:STUVI_app/API/firebase_api.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/widget/calendar_widget.dart';
import 'package:STUVI_app/Screens/home_screen.dart';
import 'package:STUVI_app/Screens/view_all_completed_page.dart';
import 'package:STUVI_app/Screens/view_all_todo_page.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:STUVI_app/provider/todos.dart';
import 'package:STUVI_app/utils/date_time.dart';
import 'package:STUVI_app/widget/completed_list_widget.dart';
import 'package:STUVI_app/widget/todo_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:provider/provider.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class DailyPlannerPage extends StatefulWidget {
  final Function(TextEditingController) onShowEmojiKeyboard;
  DateTime? selectedDateTableCalendar;

  DailyPlannerPage(
      {Key? key,
      required this.onShowEmojiKeyboard,
      required this.selectedDateTableCalendar})
      : super(key: key);

  @override
  State<DailyPlannerPage> createState() => _DailyPlannerPageState();
}

class _DailyPlannerPageState extends State<DailyPlannerPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  DateTime? selectedDateHorizontalCalendar = DateTime.now();
  DateTime? finalDate = DateTime.now();

  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        loggedInUser = UserModel.fromMap(value.data());
      });
    });
  }

  num calculateDays() {
    DateTime currentDay = DateTime.now();
    DateTime registrationDate =
        DateTime.fromMillisecondsSinceEpoch(loggedInUser.registrationDate);
    return currentDay.difference(registrationDate).inDays;
  }

  String memberDays() {
    if (calculateDays() == 1) {
      return "Member for 1 day 🙋";
    } else {
      return "Member for ${calculateDays()} days 🙋";
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildText(String text) => Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        );

    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: ((context) => HomeScreen()),
            ),
          );
        },
        iconSize: 25,
      ),
      actions: [
        IconButton(
          color: Colors.black,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                insetPadding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 145, top: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                title: Text(
                  'Choose Date',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontFamily: 'OxygenBold', color: Colors.black),
                ),
                content: Stack(
                  children: <Widget>[
                    CalendarWidget(
                      onShowEmojiKeyboard: widget.onShowEmojiKeyboard,
                    ),
                  ],
                ),
              ),
            );
          },
          icon: Icon(
            Icons.edit_calendar_rounded,
            size: 25,
          ),
        )
      ],
      elevation: 5,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontFamily: 'OxygenBold'),
      title: Text('Daily Planner'),
    );

    final dateText = Padding(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat("EEEE, d MMMM y").format(DateTime.now()),
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontFamily: 'OxygenBold'),
          ),
        ],
      ),
    );

    final userText = Padding(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            memberDays(),
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'Oxygen'),
          ),
        ],
      ),
    );

    final horizontalDatePicker = Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            dayTextStyle: TextStyle(
                fontSize: 10, color: Colors.white, fontFamily: 'Oxygen'),
            monthTextStyle: TextStyle(
                fontSize: 10, color: Colors.white, fontFamily: 'Oxygen'),
            dateTextStyle: TextStyle(
                fontSize: 20, color: Colors.white, fontFamily: 'OxygenBold'),
            selectionColor: Colors.white,
            selectedTextColor: Color(0xFF31AFE1),
            onDateChange: (date) {
              setState(
                () {
                  selectedDateHorizontalCalendar = date;
                  widget.selectedDateTableCalendar = date;
                  finalDate = date;
                },
              );
            },
          ),
        ],
      ),
    );

    final waveBox = ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        height: 228,
        width: 500,
        color: Color(0xFF31AFE1),
        child: Column(children: [
          SizedBox(height: 20),
          dateText,
          SizedBox(height: 15),
          userText,
          SizedBox(height: 15),
          horizontalDatePicker
        ]),
      ),
    );

    final myTaskstext = Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "My Tasks 📝",
            style: TextStyle(
                fontFamily: 'OxygenBold', color: Colors.black, fontSize: 20),
          ),
        ],
      ),
    );

    final toDoText = Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "To Do 📌",
            style: TextStyle(
                fontFamily: 'OxygenBold', color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );

    final viewAllOne = Padding(
      padding: const EdgeInsets.only(top: 3.5, left: 223),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => ViewAllToDoListPage()),
                ),
              );
            },
            child: Text(
              "View All >",
              style: TextStyle(
                  fontFamily: 'Oxygen', color: Colors.black, fontSize: 13),
            ),
          ),
        ],
      ),
    );

    final toDoAndViewAllText = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[toDoText, viewAllOne],
    );

    // setState(
    //   () {
    //     if (widget.selectedDateTableCalendar !=
    //         selectedDateHorizontalCalendar) {
    //       selectedDateHorizontalCalendar = widget.selectedDateTableCalendar;
    //       finalDate = widget.selectedDateTableCalendar;
    //     }
    //   },
    // );

    final todoList = Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        child: StreamBuilder<List<Todo>>(
          stream: FirebaseApi.readTodosByDateAndStatus(
            user!.uid,
            DateTimeUtil.getDate(selectedDateHorizontalCalendar)
                .toUtc()
                .millisecondsSinceEpoch,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return buildText('Something Went Wrong Try later');
                } else if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final todos = snapshot.data;

                  final provider = Provider.of<TodosProvider>(context);
                  provider.setTodos(todos!);
                  return TodoListWidget(
                      onShowEmojiKeyboard: widget.onShowEmojiKeyboard);
                }
            }
          },
        ),
      ),
    );

    final completedText = Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Completed ✅",
            style: TextStyle(
                fontFamily: 'OxygenBold', color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );

    final viewAllTwo = Padding(
      padding: const EdgeInsets.only(top: 3.5, left: 178),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => ViewAllCompletedPage()),
                ),
              );
            },
            child: Text(
              "View All >",
              style: TextStyle(
                  fontFamily: 'Oxygen', color: Colors.black, fontSize: 13),
            ),
          ),
        ],
      ),
    );

    final completedAndViewAllText = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[completedText, viewAllTwo],
    );

    final completedList = Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.30,
          child: CompletedListWidget(
            onShowEmojiKeyboard: widget.onShowEmojiKeyboard,
          )),
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              waveBox,
              myTaskstext,
              SizedBox(height: 15),
              toDoAndViewAllText,
              SizedBox(height: 15),
              todoList,
              SizedBox(height: 15),
              completedAndViewAllText,
              SizedBox(height: 15),
              completedList
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:STUVI_app/Screens/view_all_completed_page.dart';
import 'package:STUVI_app/Screens/view_all_todo_page.dart';
import 'package:STUVI_app/utils/date_time.dart';
import 'package:STUVI_app/widget/completed_list_widget.dart';
import 'package:STUVI_app/widget/daily_streak_widget.dart';
import 'package:STUVI_app/widget/on_hold_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:STUVI_app/widget/todo_list_widget.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:provider/provider.dart';
import '../API/firebase_api.dart';
import '../provider/todos.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import '../widget/percentage_indicator_widget.dart';

class HomePage extends StatefulWidget {
  final Function(TextEditingController) onShowEmojiKeyboard;

  HomePage({Key? key, required this.onShowEmojiKeyboard}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController(initialPage: 1);
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.book,
          color: Colors.black,
        ),
        onPressed: () {}, //Add pages
        iconSize: 25,
      ),
      actions: [
        IconButton(
          color: Colors.black,
          onPressed: () {}, //Add pages
          icon: Icon(
            CupertinoIcons.bell_fill,
            size: 25,
          ),
        )
      ],
      elevation: 5,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontFamily: 'OxygenBold'),
      title: Text(DateFormat("EEEE, d MMMM y").format(DateTime.now())),
    );

    // For percentage indicator and daily task streak
    final pageView = PageView(
      children: [
        PercentageIndicatorWidget(),
        DailyStreakWidget(),
      ],
      scrollDirection: Axis.horizontal,
    );

    final firstContainer = Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.25, child: pageView),
    );

    final todayAgendaText = Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Today's Agenda 📅",
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

    // For to do task
    final secondContainer = Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        child: StreamBuilder<List<Todo>>(
          stream: FirebaseApi.readTodosByDateAndStatus(
            user!.uid,
            DateTimeUtil.getTodayDate().toUtc().millisecondsSinceEpoch,
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

    // For completed task
    final thirdContainer = Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.30,
          child: CompletedListWidget(
            onShowEmojiKeyboard: widget.onShowEmojiKeyboard,
          )),
    );

    final onHoldText = Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "On Hold ⏳",
            style: TextStyle(
                fontFamily: 'OxygenBold', color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );

    final viewAllThree = Padding(
      padding: const EdgeInsets.only(top: 3.5, left: 200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "View All >",
            style: TextStyle(
                fontFamily: 'Oxygen', color: Colors.black, fontSize: 13),
          ),
        ],
      ),
    );

    final onHoldAndViewAllText = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[onHoldText, viewAllThree],
    );

    // For completed task
    final fourthContainer = Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.30,
          child: OnHoldListWidget(
            onShowEmojiKeyboard: widget.onShowEmojiKeyboard,
          )),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              appBar,
              SizedBox(height: 20),
              firstContainer,
              SizedBox(height: 15),
              todayAgendaText,
              SizedBox(height: 8),
              toDoAndViewAllText,
              SizedBox(height: 15),
              secondContainer,
              SizedBox(height: 15),
              completedAndViewAllText,
              SizedBox(height: 15),
              thirdContainer,
              SizedBox(height: 15),
              onHoldAndViewAllText,
              SizedBox(height: 15),
              fourthContainer,
              SizedBox(height: 80)
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildText(String text) => Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );

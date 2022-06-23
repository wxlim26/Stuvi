import 'package:STUVI_app/widget/completed_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:STUVI_app/widget/todo_list_widget.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:provider/provider.dart';
import 'package:STUVI_app/Screens/home_screen.dart';
import '../API/firebase_api.dart';
import '../provider/todos.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

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
      elevation: 5,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontFamily: 'OxygenBold'),
      title: Text(
        'Create Task',
      ),
    );

    // For percentage indicator and daily task streak
    final pageView = PageView(
      children: [TodoListWidget(), CompletedListWidget()],
      scrollDirection: Axis.horizontal,
    );

    final firstContainer = Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.15, child: pageView),
    );

    final todayAgendaText = Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Today's Agenda",
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
            "To Do",
            style: TextStyle(
                fontFamily: 'OxygenBold', color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );

    final viewAllOne = Padding(
      padding: const EdgeInsets.only(top: 3.5, left: 263),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "View All",
            style: TextStyle(
                fontFamily: 'Oxygen', color: Colors.black, fontSize: 13),
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
          stream: FirebaseApi.readTodos(user!.uid),
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
                  return TodoListWidget();
                }
            }
          },
        ),
      ),
    );

    final viewAllTwo = Padding(
      padding: const EdgeInsets.only(top: 3.5, left: 220),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "View All",
            style: TextStyle(
                fontFamily: 'Oxygen', color: Colors.black, fontSize: 13),
          ),
        ],
      ),
    );

    final completedText = Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Completed",
            style: TextStyle(
                fontFamily: 'OxygenBold', color: Colors.black, fontSize: 18),
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
          child: CompletedListWidget()),
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
              SizedBox(height: 8),
              todayAgendaText,
              SizedBox(height: 8),
              toDoAndViewAllText,
              SizedBox(height: 8),
              secondContainer,
              SizedBox(height: 8),
              completedAndViewAllText,
              SizedBox(height: 8),
              thirdContainer,
              SizedBox(height: 15),
              thirdContainer,
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

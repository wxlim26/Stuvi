import 'package:STUVI_app/widget/select_tasks_todo_widget.dart';
import 'package:STUVI_app/widget/todo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:STUVI_app/provider/todos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/todos.dart';

class ViewAllToDoListPage extends StatefulWidget {
  const ViewAllToDoListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewAllToDoListPage> createState() => _ViewAllToDoListPageState();
}

class _ViewAllToDoListPageState extends State<ViewAllToDoListPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todos;

    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          color: Colors.black,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                title: Text(
                  'Select Tasks',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontFamily: 'OxygenBold', color: Colors.black),
                ),
                content: SelectTasksToDoWidget(),
              ),
            );
          },
          icon: Icon(CupertinoIcons.ellipsis),
        ),
      ],
      elevation: 5,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontFamily: 'OxygenBold'),
      title: Text("To Do 📌 (${todos.length} Tasks)"),
    );

    Widget listView = Container(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        separatorBuilder: (context, index) => Container(
          height: 8,
        ),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return TodoWidget(
            todo: todo,
            onShowEmojiKeyboard: () => {},
          );
        },
      ),
    );

    final noToDo = Text(
      "No To Do's 😊",
      style: TextStyle(
        fontFamily: "Oxygen",
      ),
    );

    return Scaffold(
        appBar: appBar,
        body: todos.isEmpty
            ? Center(
                child: noToDo,
              )
            : listView);
  }
}

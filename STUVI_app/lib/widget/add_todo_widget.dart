import 'package:STUVI_app/Screens/add_task_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:STUVI_app/provider/todos.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:STUVI_app/model/user_model.dart';

class AddTaskWidget extends StatefulWidget {
  final Function(TextEditingController) onShowEmojiKeyboard;
  final Function() onHideEmojiKeyboard;
  final String emojis;

  const AddTaskWidget({
    Key? key,
    required this.onShowEmojiKeyboard,
    required this.onHideEmojiKeyboard,
    required this.emojis,
  }) : super(key: key);

  @override
  _AddTaskWidgetState createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  // TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);
  String title = '';
  String startTime = '';
  String description = '';
  int date = 0;
  String emoji = '';

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    void addTodo() {
      final isValid = _formKey.currentState!.validate();

      if (!isValid) {
        return;
      } else {
        final todo = Todo(
            id: DateTime.now().toString(),
            uid: loggedInUser.uid!,
            title: this.title,
            startTime: this.startTime,
            description: this.description,
            createdTime: DateTime.now(),
            emoji: widget.emojis,
            date: this.date);

        final provider = Provider.of<TodosProvider>(context, listen: false);
        provider.addTodo(todo, user!.uid);
        Navigator.of(context).pop();
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddTaskPage(
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedStartTime: (time) => setState(() => this.startTime = time),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
            onChangedDate: (date) => setState(() => this.date = date),
            // onChangedEmoji: (description) =>
            //     setState(() => this.emoji = description),
            onShowEmojiKeyboard: (TextEditingController controller) =>
                {widget.onShowEmojiKeyboard(controller)},
            onHideEmojiKeyboard: () => widget.onHideEmojiKeyboard(),
            onSavedToDo: addTodo,
          ),
        ],
      ),
    );
  }
}

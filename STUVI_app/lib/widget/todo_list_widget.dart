import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:STUVI_app/provider/todos.dart';
import 'package:STUVI_app/widget/todo_widget.dart';

class TodoListWidget extends StatelessWidget {
  final Function(TextEditingController) onShowEmojiKeyboard;

  TodoListWidget({Key? key, required this.onShowEmojiKeyboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todos;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: todos.isEmpty
          ? Center(
              child: Text(
                "No To Do's 😊",
                style: TextStyle(
                  fontFamily: "Oxygen",
                ),
              ),
            )
          : ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(15),
              separatorBuilder: (context, index) => Container(
                height: 8,
              ),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return TodoWidget(
                    todo: todo, onShowEmojiKeyboard: onShowEmojiKeyboard);
              },
            ),
    );
  }
}

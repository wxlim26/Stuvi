import 'package:STUVI_app/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:STUVI_app/provider/todos.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:STUVI_app/page/edit_todo_page.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;
  final Function onShowEmojiKeyboard;

  const TodoWidget(
      {Key? key, required this.todo, required this.onShowEmojiKeyboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            key: Key(todo.id.toString()),
            actions: [
              IconSlideAction(
                color: Colors.green,
                onTap: () => editTodo(context, todo),
                caption: 'Edit',
                icon: Icons.edit,
              )
            ],
            secondaryActions: [
              IconSlideAction(
                color: Colors.red,
                caption: 'Delete',
                onTap: () => deleteTodo(context, todo),
                icon: Icons.delete,
              )
            ],
            child: buildTodo(context)),
      );

  Widget buildTodo(BuildContext context) {
    final checkbox = Checkbox(
      activeColor: Colors.white,
      checkColor: Color(0xFF31AFE1),
      value: todo.isDone,
      onChanged: (_) {
        final provider = Provider.of<TodosProvider>(context, listen: false);
        provider.toggleTodoStatus(todo);

        // Utils.showSnackBar(
        //   context,
        //   isDone ? 'Task Completed' : 'Task marked Incomplete',
        // );
      },
    );

    final emojiText = Padding(
      padding: EdgeInsets.only(right: 20),
      child: Text(
        todo.emojis.join(""),
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );

    final titleText = Text(
      todo.title,
      style: TextStyle(
        fontFamily: "OxygenBold",
        color: Colors.white,
        fontSize: 18,
      ),
    );

    final timeText = Text(
      '(' + DateTimeUtil.getFormattedStartTime(todo.hour, todo.minute) + ')',
      style: TextStyle(
        fontFamily: "OxygenBold",
        color: Colors.white,
        fontSize: 18,
      ),
    );

    final descriptionText = Container(
      margin: EdgeInsets.only(top: 4),
      child: Text(
        todo.description,
        style: TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
      ),
    );

    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2A93D5),
              Color(0XFF37CAEC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
          ),
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todo.emojis.join("").isNotEmpty) emojiText,
                  if (todo.title.isNotEmpty) titleText,
                  if (DateTimeUtil.getFormattedStartTime(todo.hour, todo.minute)
                      .isNotEmpty)
                    timeText,
                  if (todo.description.isNotEmpty) descriptionText,
                ],
              ),
            ),
            checkbox
          ],
        ),
      ),
    );
  }

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(todo);

    // Utils.showSnackBar(context, 'Deleted Task');
  }

  void editTodo(BuildContext context, Todo todo) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditTodoPage(
              todo: todo, onShowEmojiKeyboard: this.onShowEmojiKeyboard),
        ),
      );
}

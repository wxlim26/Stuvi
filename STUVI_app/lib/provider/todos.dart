import 'package:flutter/cupertino.dart';
import 'package:STUVI_app/model/todo.dart';
import '../API/firebase_api.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos {
    List<Todo> notDoneTodos =
        _todos.where((todo) => todo.isDone == false).toList();
    notDoneTodos.sort((a, b) => a.hour.compareTo(b.hour));
    return notDoneTodos;
  }

  List<Todo> get todosCompleted {
    List<Todo> doneTodos = _todos.where((todo) => todo.isDone == true).toList();
    doneTodos.sort((a, b) => a.hour.compareTo(b.hour));
    return doneTodos;
  }

  void setTodos(List<Todo> todos) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _todos = todos;
        notifyListeners();
      });

  void addTodo(Todo todo, String uid) => FirebaseApi.createTodo(todo, uid);

  void removeTodo(Todo todo) => FirebaseApi.deleteTodo(todo);

  void removeToDoList(List selectedToDoList) =>
      FirebaseApi.deleteTodoList(selectedToDoList);

  bool toggleTodoStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    FirebaseApi.updateTodo(todo);
    return todo.isDone;
  }

  bool toggleTodoStatusList(List selectedToDoList) {
    for (var i = selectedToDoList.length - 1; i >= 0; i--) {
      Todo selectedTask = selectedToDoList[i];
      selectedTask.isDone = !selectedTask.isDone;
      FirebaseApi.updateTodo(selectedTask);
    }
    return true;
  }

  void updateTodo(Todo todo, String title, String description, int date,
      int hour, int minute, List<String> emojis) {
    todo.title = title;
    todo.description = description;
    todo.hour = hour;
    todo.minute = minute;
    todo.emojis = emojis;

    FirebaseApi.updateTodo(todo);
  }
}

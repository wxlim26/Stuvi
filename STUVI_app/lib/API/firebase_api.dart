import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:STUVI_app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApi {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  static Future<String> createTodo(Todo todo, String uid) async {
    final docTodo = FirebaseFirestore.instance
        .collection('todo')
        .doc(); // Creates 1 new todo in the database
    todo.id = docTodo.id;
    todo.uid = uid; // sets todo.id to the firebase id of the todo instance
    await docTodo.set(todo.toJson()); // stores todo in the firebase

    return docTodo.id;
  }

  static Stream<List<Todo>> readTodos(String uid) => FirebaseFirestore.instance
      .collection('todo')
      .where('uid', isEqualTo: uid)
      .orderBy(TodoField.createdTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(Todo.fromJson));

  static Future updateTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todo.id);

    await docTodo.update(todo.toJson());
  }

  static Future deleteTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todo.id);

    await docTodo.delete();
  }
}
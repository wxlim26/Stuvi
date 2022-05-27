import 'package:STUVI_app/utils.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  DateTime createdTime;
  String title;
  String uid;
  String id;
  String description;
  bool isDone;

  Todo({
    required this.createdTime,
    required this.title,
    this.description = '',
    required this.uid,
    required this.id,
    this.isDone = false,
  });

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        createdTime: Utils.toDateTime(json['createdTime']),
        title: json['title'],
        description: json['description'],
        uid: json['uid'],
        id: json['id'],
        isDone: json['isDone'],
      );

  Map<String, dynamic> toJson() => {
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'title': title,
        'description': description,
        'uid': uid,
        'id': id,
        'isDone': isDone,
      };
}

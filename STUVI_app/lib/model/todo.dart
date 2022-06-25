import 'package:STUVI_app/utils.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  DateTime createdTime;
  String title;
  String uid;
  String id;
  String startTime;
  String description;
  bool isDone;
  int date;
  String emoji;

  Todo({
    required this.createdTime,
    required this.title,
    this.startTime = '',
    this.description = '',
    required this.uid,
    required this.id,
    this.isDone = false,
    this.date = 0,
    this.emoji = '',
  });

  static Todo fromJson(Map<String, dynamic> json) => Todo(
      createdTime: Utils.toDateTime(json['createdTime']),
      title: json['title'],
      startTime: json['startTime'],
      description: json['description'],
      uid: json['uid'],
      id: json['id'],
      isDone: json['isDone'],
      date: json['date'],
      emoji: json['emoji']);

  Map<String, dynamic> toJson() => {
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'title': title,
        'startTime': startTime,
        'description': description,
        'uid': uid,
        'id': id,
        'isDone': isDone,
        'date': date,
        'emoji': emoji
      };
}
